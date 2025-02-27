import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:voccent/classroom/cubit/models/classroom.dart';
import 'package:voccent/classroom/cubit/models/classroom_object.dart';
import 'package:voccent/home/cubit/models/user/user.dart';
import 'package:voccent/http/response_data.dart';
import 'package:voccent/http/user_token.dart';
import 'package:voccent/web_socket/web_socket.dart';

part 'classroom_state.dart';

class ClassroomCubit extends Cubit<ClassroomState> {
  ClassroomCubit(
    this._socket,
    this._userToken,
    this.user,
    this._client,
  ) : super(const ClassroomState()) {
    _socketSubscription = _socket.dataStream.listen(
      _onData,
      onDone: _onDone,
      onError: _onError,
    );

    _socketEventsSubscription = _socket.eventsStream.listen(
      _onSocketEvent,
      onDone: _onEventsDone,
    );
  }

  final User user;
  final UserToken _userToken;
  final Client _client;
  final WebSocket _socket;
  late StreamSubscription<Map<String, dynamic>> _socketSubscription;
  late StreamSubscription<EventType> _socketEventsSubscription;

  @override
  void emit(ClassroomState state) {
    if (isClosed) {
      return;
    }

    super.emit(state);
  }

  void _onEventsDone() {
    _socketEventsSubscription.cancel();
  }

  Future<void> _onSocketEvent(EventType evt) async {
    switch (evt) {
      case EventType.connected:
        emit(
          state.copyWith(
            classroomTicketToken: await _generateTicketToken('classroom_user'),
          ),
        );
      case EventType.disconnected:
        break;
    }
  }

  Future<void> _onData(Map<String, dynamic> frame) async {
    log(frame.toString(), name: 'Classroom');

    if (frame['Data'] == null) {
      return;
    }

    if (frame['Type'] == 'error') {
      throw Exception(frame['Data'] as String);
    }

    final Map<String, dynamic> data;

    if (frame['Data'] is Map<String, dynamic>) {
      data = frame['Data'] as Map<String, dynamic>;
    } else if (frame['Data'] is String) {
      data = jsonDecode(frame['Data'] as String) as Map<String, dynamic>;
    } else {
      throw Exception('ece8d4dd: Unexpected server response');
    }

    if (frame['Ticket'] == 'classroom_user' && frame['Type'] == 'message') {
      if (data['Operation'] == 'delete_classroom') {
        final id = data['Object'] as String;
        final classroom = state.classrooms
            .firstWhere((element) => element.classroom!.id == id);
        _deleteClassroom(classroom);
        return;
      }

      final classroom =
          ClassroomObject.fromJson(data['Object'] as Map<String, dynamic>);
      if (data['Operation'] == 'create_classroom') {
        final createdClassroom =
            Classroom.fromJson(data['Object'] as Map<String, dynamic>);
        _onCreateClassroom(createdClassroom);
        return;
      }

      if (data['Operation'] == 'update_permission_user') {
        _onUpdatePermissions(classroom);
        return;
      }
    }
  }

  void _onDone() {
    _socketSubscription.cancel();
  }

  void _onError(dynamic error) {
    log(error.toString(), name: 'Classroom');
  }

  Future<void> loadClassrooms() async {
    try {
      final response =
          await _client.get(Uri.parse('/api/v1/classroom/user')).listData();

      final classrooms = response
          .map(
            (dynamic e) => ClassroomObject.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      final current = <ClassroomObject>[];
      final invitations = <ClassroomObject>[];
      final rejected = <ClassroomObject>[];

      for (var i = 0; i < classrooms.length; i++) {
        switch (classrooms[i].confirmation?.status) {
          case 'rejected':
          case 'canceled':
            rejected.add(classrooms[i]);
          case 'invited':
          case 'requested':
            invitations.add(classrooms[i]);
          case 'resolved':
          case 'confirmed':
          default:
            current.add(classrooms[i]);
            break;
        }
      }

      emit(
        state.copyWith(
          classrooms: classrooms,
          current: current,
          invitations: invitations,
          rejected: rejected,
          uiLoading: false,
        ),
      );

      await _initWS();
    } catch (e) {
      emit(state.copyWith(uiLoading: false));
      rethrow;
    }
  }

  Future<void> _initWS() async {
    emit(
      state.copyWith(
        classroomTicketToken: await _generateTicketToken('classroom_user'),
      ),
    );
  }

  Future<String> _generateTicketToken(String ticket) async {
    final map = await _socket.request(
      <String, dynamic>{
        'Token': await _userToken.value(),
        'Type': 'generate_ticket_token',
      },
      ticket,
      '${user.id}',
    );

    if (map['Type'] == 'error') {
      throw Exception(map['Data']);
    }

    return map['TicketToken'] as String;
  }

  void _onCreateClassroom(Classroom classroom) {
    final newClassroomObject = ClassroomObject(classroom: classroom);
    final classrooms = List<ClassroomObject>.from(state.classrooms)
      ..add(newClassroomObject);
    final current = List<ClassroomObject>.from(state.current)
      ..add(newClassroomObject);

    emit(
      state.copyWith(
        classrooms: classrooms,
        current: current,
        newClassroomId: classroom.id,
      ),
    );
  }

  void _onUpdatePermissions(ClassroomObject classroomObject) {
    final updateClassroom = state.classrooms.firstWhere(
      (element) => element.classroom!.id == classroomObject.classroom!.id,
      orElse: () => const ClassroomObject(),
    );

    if (updateClassroom.classroom != null) {
      _deleteClassroom(updateClassroom);
      _addClassroom(classroomObject);
    } else {
      _addClassroom(classroomObject);
    }
  }

  void _addClassroom(ClassroomObject classroomObject) {
    switch (classroomObject.confirmation!.status) {
      case 'resolved':
      case 'confirmed':
        final updateClassrooms = List<ClassroomObject>.from(state.classrooms)
          ..add(classroomObject);
        final updateCurrent = List<ClassroomObject>.from(state.current)
          ..add(classroomObject);
        emit(
          state.copyWith(
            classrooms: updateClassrooms,
            current: updateCurrent,
          ),
        );
      case 'invited':
      case 'requested':
        final updateClassrooms = List<ClassroomObject>.from(state.classrooms)
          ..add(classroomObject);
        final updateInvitations = List<ClassroomObject>.from(state.invitations)
          ..add(classroomObject);
        emit(
          state.copyWith(
            classrooms: updateClassrooms,
            invitations: updateInvitations,
          ),
        );
      case 'rejected':
      case 'canceled':
        final updateClassrooms = List<ClassroomObject>.from(state.classrooms)
          ..add(classroomObject);
        final updateRejected = List<ClassroomObject>.from(state.rejected)
          ..add(classroomObject);
        emit(
          state.copyWith(
            classrooms: updateClassrooms,
            rejected: updateRejected,
          ),
        );
    }
  }

  void _deleteClassroom(ClassroomObject classroomObject) {
    if (classroomObject.confirmation == null) {
      final updateClassrooms = List<ClassroomObject>.from(state.classrooms)
        ..remove(classroomObject);
      final updateCurrent = List<ClassroomObject>.from(state.current)
        ..remove(classroomObject);
      emit(
        state.copyWith(
          classrooms: updateClassrooms,
          current: updateCurrent,
        ),
      );
      return;
    }

    switch (classroomObject.confirmation?.status) {
      case 'resolved':
      case 'confirmed':
        final updateClassrooms = List<ClassroomObject>.from(state.classrooms)
          ..remove(classroomObject);
        final updateCurrent = List<ClassroomObject>.from(state.current)
          ..remove(classroomObject);
        emit(
          state.copyWith(
            classrooms: updateClassrooms,
            current: updateCurrent,
          ),
        );
      case 'invited':
      case 'requested':
        final updateClassrooms = List<ClassroomObject>.from(state.classrooms)
          ..remove(classroomObject);
        final updateInvitations = List<ClassroomObject>.from(state.invitations)
          ..remove(classroomObject);
        emit(
          state.copyWith(
            classrooms: updateClassrooms,
            invitations: updateInvitations,
          ),
        );
      case 'rejected':
      case 'canceled':
        final updateClassrooms = List<ClassroomObject>.from(state.classrooms)
          ..remove(classroomObject);
        final updateRejected = List<ClassroomObject>.from(state.rejected)
          ..remove(classroomObject);
        emit(
          state.copyWith(
            classrooms: updateClassrooms,
            rejected: updateRejected,
          ),
        );
    }
  }

  Future<void> joinClassroom(String classroomName) async {
    _socket.send(
      <String, dynamic>{
        'Data': <String, dynamic>{
          'Operation': 'request_join',
          'Object': {
            'ClassroomName': classroomName,
          },
        },
        'TicketToken': state.classroomTicketToken,
        'Type': 'message',
      },
    );
  }

  void joinClassroomAgain(String classroomName) {
    _socket.send(
      <String, dynamic>{
        'Data': <String, dynamic>{
          'Operation': 'request_join',
          'Object': {
            'ClassroomName': classroomName,
          },
        },
        'TicketToken': state.classroomTicketToken,
        'Type': 'message',
      },
    );
  }

  void cancelJoin(String classroomName) {
    _socket.send(
      <String, dynamic>{
        'Data': <String, dynamic>{
          'Operation': 'cancel_join',
          'Object': {
            'ClassroomName': classroomName,
          },
        },
        'TicketToken': state.classroomTicketToken,
        'Type': 'message',
      },
    );
  }

  void confirmJoin(String classroomName) {
    _socket.send(
      <String, dynamic>{
        'Data': <String, dynamic>{
          'Operation': 'confirm_join',
          'Object': {
            'ClassroomName': classroomName,
          },
        },
        'TicketToken': state.classroomTicketToken,
        'Type': 'message',
      },
    );
  }

  void createClassroom() {
    if (state.newClassroomName.length < 2) {
      return;
    }

    emit(state.copyWith(newClassroomCreating: true));
    _socket.send(
      <String, dynamic>{
        'Data': <String, dynamic>{
          'Operation': 'create_classroom',
          'Object': {
            'Name': state.newClassroomName,
          },
        },
        'TicketToken': state.classroomTicketToken,
        'Type': 'message',
      },
    );
  }

  void setNewClassroomName(String name) {
    emit(state.copyWith(newClassroomName: name));
  }

  void classroomCreationDone() {
    emit(state.copyWith(newClassroomCreating: false));
  }

  Future<List<Classroom>> searchClassroom(String value) async {
    if (value.length < 2) {
      return [];
    }

    final response = await _client
        .get(
          Uri.parse(
            '/api/v1/search/classroom?q=${Uri.encodeComponent(value)}',
          ),
        )
        .listData();

    final classrooms = response
        .map(
          (dynamic element) =>
              Classroom.fromJson(element as Map<String, dynamic>),
        )
        .toList();

    final filteredClassrooms =
        classrooms.where((element) => element.createdby != user.id).toList();

    return filteredClassrooms;
  }

  void setJoinButton({required bool canJoin}) {
    emit(state.copyWith(canJoin: canJoin));
  }

  void deleteClassroom(String id) {
    _socket.send(
      <String, dynamic>{
        'Data': <String, dynamic>{
          'Operation': 'classroom_delete',
          'Object': {
            'ID': id,
          },
        },
        'TicketToken': state.classroomTicketToken,
        'Type': 'message',
      },
    );
  }

  @override
  Future<void> close() {
    if (state.classroomTicketToken != null) {
      _socket.send(
        <String, dynamic>{
          'TicketToken': state.classroomTicketToken,
          'Type': 'remove_ticket_token',
        },
      );
    }
    _socketSubscription.cancel();
    _socketEventsSubscription.cancel();
    return super.close();
  }
}
