import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/classroom_card/cubit/models/classroom_card_model.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/home/cubit/models/user/user.dart';
import 'package:voccent/http/response_data.dart';
import 'package:voccent/http/server_exception.dart';
import 'package:voccent/http/user_token.dart';
import 'package:voccent/updater_service/updater_service.dart';
import 'package:voccent/web_socket/web_socket.dart';

part 'classroom_card_state.dart';

class ClassroomCardCubit extends Cubit<ClassroomCardState> {
  ClassroomCardCubit(
    this._socket,
    this._userToken,
    this._client,
    this._sharedPreferences,
    this._updaterService,
  ) : super(const ClassroomCardState()) {
    _socketSubscription = _socket.dataStream.listen(
      _onData,
      onDone: _onDone,
      onError: _onError,
    );

    _socketEventsSubscription = _socket.eventsStream.listen(
      _onSocketEvent,
      onDone: _onEventsDone,
    );
    _updatePlanProgressSubscription =
        _updaterService.planProgressUpdate.listen(fetchClassroom);
  }

  @override
  void emit(ClassroomCardState state) {
    if (isClosed) {
      return;
    }
    super.emit(state);
  }

  final WebSocket _socket;
  final UserToken _userToken;
  late StreamSubscription<Map<String, dynamic>> _socketSubscription;
  late StreamSubscription<EventType> _socketEventsSubscription;
  final Client _client;
  final SharedPreferences _sharedPreferences;
  final UpdaterService _updaterService;
  StreamSubscription<Object?>? _updatePlanProgressSubscription;

  void setCode(
    String? classroomId,
    String? code,
  ) {
    emit(
      state.copyWith(
        classroomId: classroomId,
        code: code,
      ),
    );
  }

  void setRecentClassroom(String classroomId) {
    final recentClassrooms =
        _sharedPreferences.getStringList('recent_classrooms_ids') ?? [];

    if (recentClassrooms.contains(classroomId)) {
      recentClassrooms
        ..remove(classroomId)
        ..insert(0, classroomId);

      _sharedPreferences.setStringList(
        'recent_classrooms_ids',
        recentClassrooms,
      );
    } else {
      recentClassrooms.insert(0, classroomId);

      _sharedPreferences.setStringList(
        'recent_classrooms_ids',
        recentClassrooms,
      );
    }
  }

  Future<void> fetchClassroom(User user) async {
    try {
      if (user.id == null) return;
      if (state.code != null) {
        final uri = '/api/v1/classroom/join_by_code/${state.code}';
        final response = await _client.post(
          Uri.parse(uri),
          body: '{"classroomId": "classroomId"}',
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        );

        // ignore: parameter_assignments
        final classroomId = response.mapData().values.first.toString();
        emit(state.copyWith(classroomId: classroomId));
      }

      final response = await _client
          .get(
            Uri.parse(
              '/api/v1/classroom/${state.classroomId}?with_current_plans=true',
            ),
          )
          .mapData();
      setRecentClassroom('${state.classroomId}');
      _updaterService.updateRecentClassrooms('${state.classroomId}');
      emit(
        state.copyWith(
          user: user,
          classroom: ClassroomCardModel.fromJson(response),
        ),
      );

      await updateUserLanguages(user);

      emit(
        state.copyWith(
          loaded: true,
          classroomUserTicketToken:
              await _generateTicketTokenClassroomUser('classroom_user'),
        ),
      );
    } catch (err) {
      emit(
        state.copyWith(
          loaded: true,
          error: err.toString(),
        ),
      );
    }
  }

  Future<void> updateUserLanguages(User user) async {
    final code = _sharedPreferences.getString('joinCode');
    if (code != null && code.isNotEmpty) {
      await _sharedPreferences.remove('joinCode');
      final listId = state.classroom?.languageIds ?? [];
      if (listId.isNotEmpty) {
        final listWorklang = Dictionary.languages
            .where((element) => listId.contains(element.id))
            .toList();

        final reqBody = <String, dynamic>{
          'firstname': user.firstname,
          'lastname': user.lastname,
          'username': user.username,
          'CurrentLang': state.user.currentlang,
          'WorkLang': listWorklang.map((e) => e.toUserLanguage()).toList(),
        };

        await _client.patch(
          Uri.parse(
            '/api/v1/user/userid/${state.user.id}',
          ),
          body: json.encode(reqBody),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        );
      }
    }
  }

  Future<void> _onData(Map<String, dynamic> frame) async {
    if (frame['Ticket'] == 'classroom_user') {
      if (frame['Data'] == null) {
        return;
      }

      if (frame['Type'] == 'error') {
        emit(
          state.copyWith(
            loading: false,
          ),
        );

        throw ServerException(frame['Data'] as String);
      }

      final Map<String, dynamic> data;

      if (frame['Data'] is Map<String, dynamic>) {
        data = frame['Data'] as Map<String, dynamic>;
      } else if (frame['Data'] is String) {
        data = jsonDecode(frame['Data'] as String) as Map<String, dynamic>;
      } else {
        throw Exception('98dbe8e3: Unexpected server response');
      }

      if (frame['Ticket'] == 'classroom_user' && frame['Type'] == 'message') {
        if (data['Operation'] == 'update_permission_user') {
          emit(
            state.copyWith(
              classroom: state.copyClassroomWith(
                confirmation: ClassroomCardConfirmationModel.fromJson(
                  (data['Object'] as Map<String, dynamic>)['Confirmation']
                      as Map<String, dynamic>,
                ),
                classroom: ClassroomCardClassroomModel.fromJson(
                  (data['Object'] as Map<String, dynamic>)['Classroom']
                      as Map<String, dynamic>,
                ),
              ),
            ),
          );
          emit(
            state.copyWith(
              loading: false,
            ),
          );
          return;
        }
      }
    }
  }

  void joinClassroom() {
    emit(
      state.copyWith(
        loading: true,
      ),
    );
    _socket.send(
      <String, dynamic>{
        'Data': <String, dynamic>{
          'Operation': 'request_join',
          'Object': {
            'ClassroomName': state.classroom?.classroom?.name,
          },
        },
        'TicketToken': state.classroomUserTicketToken,
        'Type': 'message',
      },
    );
    _updaterService
      ..fetchMyClassrooms(null)
      ..updateMembersOfClassroom(null)
      ..updateUser(_client);
  }

  void removeRecentClassroom(String id) {
    final recentClassrooms =
        _sharedPreferences.getStringList('recent_classrooms_ids') ?? [];

    if (recentClassrooms.contains(id)) {
      recentClassrooms.remove(id);

      _sharedPreferences.setStringList(
        'recent_classrooms_ids',
        recentClassrooms,
      );
    }
    _updaterService.updateRecentClassrooms(id);
  }

  Future<void> cancelJoinClassroom() async {
    emit(
      state.copyWith(
        loading: true,
      ),
    );
    await _socket.request(
      <String, dynamic>{
        'Data': <String, dynamic>{
          'Operation': 'cancel_join',
          'Object': {
            'ClassroomName': state.classroom?.classroom?.name,
          },
        },
        'TicketToken': state.classroomUserTicketToken,
        'Type': 'message',
      },
      'classroom_user',
      '${state.user.id}',
    );
    _updaterService
      ..fetchMyClassrooms(null)
      ..updateMembersOfClassroom(null)
      ..updateUser(_client);
  }

  void confirmJoinClassroom() {
    emit(
      state.copyWith(
        loading: true,
      ),
    );
    _socket.send(
      <String, dynamic>{
        'Data': <String, dynamic>{
          'Operation': 'confirm_join',
          'Object': {
            'ClassroomName': state.classroom?.classroom?.name,
          },
        },
        'TicketToken': state.classroomUserTicketToken,
        'Type': 'message',
      },
    );
    _updaterService
      ..fetchMyClassrooms(null)
      ..updateUser(_client);
  }

  Future<void> foundBarcode(BarcodeCapture barcodeCapture) async {
    final barcodes = barcodeCapture.barcodes;
    if (barcodes.isNotEmpty) {
      final barcode = barcodes.first;
      final code = barcode.rawValue.toString().split('/').last;
      fillEnterCode(code);
    }
  }

  Future<void> foundBarcodeJoinCode(String joinCode) async => fillEnterCode(
        joinCode,
      );

  Future<String> joinClassroomByCode(User user) async {
    emit(
      state.copyWith(
        isLoadingJoinCode: false,
        user: user,
      ),
    );
    try {
      var code = state.enterCode;
      code = code.substring(code.lastIndexOf('/') + 1);

      final uri = '/api/v1/classroom/join_by_code/$code';

      emit(state.copyWith(isCodeValid: true, isLoadingJoinCode: true));
      final response = await _client.post(
        Uri.parse(uri),
        body: '{"classroomId": "classroomId"}',
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final newJoin = response.mapData()['NewJoin'] as bool? ?? false;
      final focusOrganizationID =
          response.mapData()['FocusOrganizationID'] as String?;
      if (focusOrganizationID != null && newJoin) {
        _updaterService.updateUser(_client);
      }

      emit(state.copyWith(isLoadingJoinCode: false));
      final newClassroomID = response.mapData().values.first.toString();
      return newClassroomID;
    } catch (e) {
      emit(state.copyWith(isCodeValid: false, isLoadingJoinCode: false));
      Future.delayed(const Duration(seconds: 1), resetCode);

      rethrow;
    }
  }

  void resetCode() {
    emit(state.copyWith(isCodeValid: true, enterCode: ''));
  }

  void fillEnterCode(String value) {
    emit(state.copyWith(enterCode: value));
  }

  void setPlanUserPassing(int index) {
    final plans =
        List<ClassroomCardPlanModel>.from(state.classroom!.currentPlans!);

    plans[index] = plans[index].copyWith(userPassing: true);

    emit(
      state.copyWith(
        classroom: state.classroom!.copyWith(
          currentPlans: plans,
        ),
      ),
    );
  }

  Future<String> _generateTicketTokenClassroomUser(String ticket) async {
    final map = await _socket.request(
      <String, dynamic>{
        'Token': await _userToken.value(),
        'Type': 'generate_ticket_token',
      },
      ticket,
      '${state.user.id}',
    );

    if (!map.containsKey('TicketToken')) {
      throw Exception(map['Data']);
    }

    return map['TicketToken'] as String;
  }

  void _onDone() {
    _socketSubscription.cancel();
  }

  void _onError(dynamic error) {
    log(error.toString(), name: 'Classroom_card_cubit');
  }

  Future<void> _onSocketEvent(EventType evt) async {
    switch (evt) {
      case EventType.connected:
        emit(
          state.copyWith(
            classroomUserTicketToken:
                await _generateTicketTokenClassroomUser('classroom_user'),
          ),
        );
      case EventType.disconnected:
        break;
    }
  }

  void _onEventsDone() {
    _socketEventsSubscription.cancel();
  }

  @override
  Future<void> close() {
    if (state.classroomUserTicketToken != null ||
        state.classroomUserTicketToken != '') {
      _socket.send(
        <String, dynamic>{
          'TicketToken': state.classroomUserTicketToken,
          'Type': 'remove_ticket_token',
        },
      );
    }
    _socketSubscription.cancel();
    _socketEventsSubscription.cancel();
    _updatePlanProgressSubscription?.cancel();
    return super.close();
  }
}
