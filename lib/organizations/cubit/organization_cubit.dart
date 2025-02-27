import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/home/cubit/models/user/user.dart';
import 'package:voccent/http/response_data.dart';
import 'package:voccent/http/user_token.dart';
import 'package:voccent/organizations/cubit/models/org/confirmation.dart';
import 'package:voccent/organizations/cubit/models/org/org.dart';
import 'package:voccent/organizations/cubit/models/org/organization.dart';
import 'package:voccent/web_socket/web_socket.dart';

part 'organization_state.dart';

class OrganizationCubit extends Cubit<OrganizationState> {
  OrganizationCubit(
    this._client,
    this._socket,
    this._userToken,
    this._sharedPreferences,
  ) : super(const OrganizationState()) {
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

  final SharedPreferences _sharedPreferences;
  final UserToken _userToken;
  final Client _client;
  final WebSocket _socket;
  late StreamSubscription<Map<String, dynamic>> _socketSubscription;
  late StreamSubscription<EventType> _socketEventsSubscription;

  Future<void> init(User user) async {
    await _loadOrganization();
    emit(
      state.copyWith(
        userOrganizationTicketToken: await _generateTicketToken(
          'organization_user',
          user.id!,
        ),
      ),
    );
  }

  Future<void> _loadOrganization() async {
    final response = await _client
        .get(
          Uri.parse(
            'api/v1/organizations/user',
          ),
        )
        .mapData();

    final org = Org.fromJson(response);

    emit(
      state.copyWith(
        confirmations: org.confirmations,
        organization: org.organization,
        isLoading: false,
      ),
    );

    await _sharedPreferences.setString(
      'OrganizationID',
      org.organization?.id ?? '',
    );
  }

  Future<void> leaveOrganization(String? objectId) async {
    final data = {
      'Operation': 'cancel_join',
      'Object': {'ObjectID': objectId},
    };

    _socket.send(
      <String, dynamic>{
        'Data': data,
        'TicketToken': state.userOrganizationTicketToken,
        'Type': 'message',
      },
    );

    await _sharedPreferences.remove(
      'OrganizationID',
    );
  }

  Future<void> joinOrganization(Confirmation? confirmation) async {
    final data = {
      'Operation': 'confirm_join',
      'Object': {'ObjectID': confirmation?.objectId},
    };

    _socket.send(
      <String, dynamic>{
        'Data': data,
        'TicketToken': state.userOrganizationTicketToken,
        'Type': 'message',
      },
    );

    await _sharedPreferences.setString(
      'OrganizationID',
      confirmation?.objectId ?? '',
    );
  }

  Future<void> _onData(Map<String, dynamic> frame) async {
    if (frame['Ticket'] == 'organization_user') {
      if (frame['Type'] == 'error' || frame['Data'] == null) {
        return;
      }

      final data = frame['Data'] as Map<String, dynamic>?;

      if (data != null) {
        final object = data['Object'] as Map<String, dynamic>?;

        if (object != null && object['ObjectID'] != null) {
          final status = object['Status'] as String?;
          final isCancelled = status == 'canceled';

          emit(
            state.copyWith(
              organization: Organization(
                name: status == 'invited'
                    ? object['ObjectName'] as String? ?? ''
                    : state.organization?.name ?? '',
              ),
            ),
          );

          final confirmation = isCancelled
              ? null
              : Confirmation(
                  id: object['ID'] as String? ?? '',
                  objectId: object['ObjectID'] as String? ?? '',
                  objectName: state.organization?.name ?? '',
                  sharedWith: object['SharedWith'] as String? ?? '',
                  sharedWithName: object['SharedWithName'] as String? ?? '',
                  sharedWithEmail: object['SharedWithEmail'] as String? ?? '',
                  type: object['Type'] as String? ?? '',
                  status: status ?? '',
                );

          emit(
            state.copyWith(
              confirmations: confirmation != null ? [confirmation] : [],
              isLoading: false,
            ),
          );

          await _loadOrganization();
        }
      }
    }
  }

  void _onDone() {
    _socketSubscription.cancel();
  }

  Future<void> _onError(dynamic error) async {}

  Future<void> _onSocketEvent(EventType evt) async {
    switch (evt) {
      case EventType.connected:
        _socket.send(
          <String, dynamic>{
            'Token': await _userToken.value(),
            'Type': 'connect',
          },
        );
        await FirebaseCrashlytics.instance
            .log('53ee472e: generated new tokens');
      case EventType.disconnected:
        await FirebaseCrashlytics.instance
            .log('9681ace3: WS status disconnected :(');
    }
  }

  void _onEventsDone() {
    _socketEventsSubscription.cancel();
  }

  Future<String> _generateTicketToken(String ticket, String operationId) async {
    final map = await _socket.request(
      <String, dynamic>{
        'Token': await _userToken.value(),
        'Type': 'generate_ticket_token',
      },
      ticket,
      operationId,
    );

    if (map['Type'] == 'error') {
      throw Exception(map['Data']);
    }

    return map['TicketToken'] as String;
  }

  @override
  Future<void> close() async {
    _socket.send(
      <String, dynamic>{
        'TicketToken': state.userOrganizationTicketToken,
        'Type': 'remove_ticket_token',
      },
    );
    return super.close();
  }

  @override
  void emit(OrganizationState state) {
    if (isClosed) {
      return;
    }

    super.emit(state);
  }
}
