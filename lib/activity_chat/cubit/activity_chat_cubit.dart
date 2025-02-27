import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synchronized/synchronized.dart';
import 'package:voccent/activity_chat/cubit/models/chat_user.dart';
import 'package:voccent/activity_chat/cubit/models/messages/message.dart';
import 'package:voccent/activity_chat/cubit/models/messages/meta.dart';
import 'package:voccent/home/cubit/models/user/user.dart';
import 'package:voccent/http/user_token.dart';

import 'package:voccent/web_socket/web_socket.dart';

part 'activity_chat_state.dart';

class ActivityChatCubit extends Cubit<ActivityChatState> {
  ActivityChatCubit(
    this._socket,
    this._userToken,
  ) : super(
          const ActivityChatState(
            user: User(),
            messages: [],
          ),
        ) {
    _socketSubscription = _socket.dataStream.listen(
      _onWebSocketDataSync,
      onDone: _onWebSocketDone,
      onError: _onWebSocketError,
    );

    _socketEventsSubscription = _socket.eventsStream.listen(
      _onSocketEvent,
      onDone: _onSocketEventsDone,
    );
  }

  final WebSocket _socket;
  late StreamSubscription<Map<String, dynamic>> _socketSubscription;
  late StreamSubscription<EventType> _socketEventsSubscription;
  final UserToken _userToken;
  final _lock = Lock();
  static const limit = 50;
  static const voccentAiId = '10000000-0000-0000-0000-000000000000';

  Future<void> init({String? operationId, bool? isVoccentAI}) async {
    emit(
      state.copyWith(
        status: Status.loading,
        isVoccentAI: isVoccentAI,
      ),
    );
    await _initWs(operationId);
    _getInfo();
    getMessages();
    emit(
      state.copyWith(
        status: Status.ready,
      ),
    );
  }

  Future<void> _initWs(String? operationId) async {
    emit(
      state.copyWith(
        ticketToken: await _generateTicketToken(
          'activity',
          operationId ?? '',
        ),
        operationId: operationId,
      ),
    );
  }

  void _getInfo() {
    final data = {
      'Operation': 'get_info',
    };
    _socket.send(
      <String, dynamic>{
        'Data': data,
        'TicketToken': state.ticketToken,
        'Type': 'message',
      },
    );
  }

  void getMessages() {
    if (state.hasReachedMax) return;

    final data = {
      'Object': {
        'limit': limit,
        'lastid': state.lastId.isEmpty ? null : state.lastId,
        'OrderDesc': state.orderDesc,
        'OrderAsc': state.orderAsc,
      },
      'Operation': 'get_messages',
    };

    _socket.send({
      'Data': data,
      'TicketToken': state.ticketToken,
      'Type': 'message',
    });
  }

  Future<void> _onWebSocketDataSync(Map<String, dynamic> frame) async {
    await _lock.synchronized(() => _onWebSocketData(frame));
  }

  Future<void> _onWebSocketData(Map<String, dynamic> frame) async {
    developer.log(frame.toString(), name: 'ActivityChat');

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
      throw Exception('f945a27a: Unexpected server response');
    }

    if (frame['Ticket'] == 'activity' && frame['Type'] == 'message') {
      switch (data['Operation'] as String) {
        case 'get_info':
          if (data['Object'] != null) {
            final objects = data['Object'] as Map<String, dynamic>;

            /// Handle Users.
            if (objects['Users'] != null) {
              final usersDynamic = objects['Users'] as List<dynamic>;
              final users = usersDynamic
                  .map(
                    (userMap) => User.fromJson(userMap as Map<String, dynamic>),
                  )
                  .toSet()
                  .toList();

              emit(state.copyWith(usersOnline: users));
            }

            /// Handle ChatID.
            if (objects['ChatID'] != null) {
              emit(state.copyWith(chatId: objects['ChatID'] as String));
            }

            /// Handle ChatUser.
            if (objects['ChatUser'] != null) {
              final chatUser = ChatUser.fromJson(
                objects['ChatUser'] as Map<String, dynamic>,
              );
              emit(state.copyWith(chatUser: chatUser));
              if (chatUser.newMessageID == null) {
                emit(state.copyWith(orderAsc: false, orderDesc: true));
              }
              if (chatUser.newMessageID != null) {
                emit(
                  state.copyWith(
                    orderAsc: true,
                    orderDesc: true,
                    newMessageID: chatUser.newMessageID ?? '',
                  ),
                );
              }

              /// Handle MuteRules.
              emit(
                state.copyWith(
                  muteUser: chatUser.muteUser,
                  muteAuthor: chatUser.muteAuthor,
                ),
              );
            }
          }
        case 'user_connect':
          if (data['Object'] != null) {
            final object = data['Object'] as Map<String, dynamic>;
            final user = User.fromJson(object);
            final usersOnline = List<User>.from(state.usersOnline)..add(user);

            emit(state.copyWith(usersOnline: usersOnline.toSet().toList()));
          }
        case 'user_disconnect':
          if (data['Object'] != null) {
            final object = data['Object'] as Map<String, dynamic>;
            final userDisconnectId = object['ID'];

            final usersOnline = List<User>.from(state.usersOnline)
              ..removeWhere((user) => user.id == userDisconnectId);

            emit(state.copyWith(usersOnline: usersOnline));
          }
        case 'get_messages':
          if (data['Object'] != null) {
            final objects = data['Object'] as Map<String, dynamic>;
            if (objects.containsKey('Messages') &&
                objects['Messages'] is List) {
              final messagesData = objects['Messages'] as List<dynamic>;
              final newMessages = messagesData.map((messageData) {
                return Message.fromJson(messageData as Map<String, dynamic>);
              }).toList();

              final allMessages = List<Message>.from(state.messages)
                ..insertAll(0, newMessages);

              if (newMessages.isNotEmpty) {
                final lastMessageId = newMessages.first.id;
                emit(state.copyWith(lastId: lastMessageId));
              }

              if (newMessages.length < limit) {
                emit(state.copyWith(hasReachedMax: true));
              }

              emit(state.copyWith(messages: allMessages));
            }
            if (state.newMessageID.isNotEmpty) {
              _sendReadMessage();
            }
          }

        case 'chat_new_message':
          final messageData = data['Object'] as Map<String, dynamic>;
          final newMessage = Message.fromJson(messageData);

          final messages = List<Message>.from(
            state.messages,
          )..add(
              newMessage,
            );
          if (state.requestStreamotionButton) {
            _showStreamotionButton();
          }
          if (state.isVoccentAI && newMessage.createdby != voccentAiId) {
            emit(state.copyWith(isTyping: true));
          }

          final pattern = RegExp('"([^"]*)"');
          final matches = pattern.allMatches(newMessage.meta.first.body ?? '');
          var phraseInQuotes = '';
          if (matches.isNotEmpty) {
            phraseInQuotes = matches.first.group(1) ?? '';
          }
          emit(
            state.copyWith(
              messages: messages,
              query: phraseInQuotes,
            ),
          );

          if (state.isVoccentAI && newMessage.createdby == voccentAiId) {
            emit(
              state.copyWith(
                isTyping: false,
              ),
            );
          }
          _sendReadMessage();
        case 'chat_delete_message':
          final messages = List<Message>.from(
            state.messages,
          );
          final deleteMetaObject = data['Object'] as Map<String, dynamic>;
          final deleteId = deleteMetaObject['ID'] as String;
          messages.removeWhere((message) => message.id == deleteId);
          for (final message in messages) {
            message.meta.removeWhere((metaItem) => metaItem.id == deleteId);
          }
          emit(state.copyWith(messages: messages));

        case 'chat_update_message':
          final updatedMessageData = data['Object'] as Map<String, dynamic>;
          final updateId = updatedMessageData['MessageID'] as String;
          final updatedMessages = List<Message>.from(state.messages);

          for (var i = 0; i < updatedMessages.length; i++) {
            if (updatedMessages[i].id == updateId) {
              final newMeta = Meta.fromJson(updatedMessageData);
              updatedMessages[i] = updatedMessages[i].copyWith(meta: [newMeta]);
              break;
            }
          }

          emit(state.copyWith(messages: updatedMessages));

        case 'change_mute':
          final muteObject = data['Object'] as Map<String, dynamic>;
          if (muteObject.containsKey('MuteUser')) {
            emit(
              state.copyWith(
                muteUser: muteObject['MuteUser'] as bool,
              ),
            );
          }
          if (muteObject.containsKey('MuteAuthor')) {
            emit(
              state.copyWith(
                muteAuthor: muteObject['MuteAuthor'] as bool,
              ),
            );
          }
      }
    }
  }

  void _sendReadMessage() {
    final data = {
      'Object': {
        'MessageID': state.messages.last.id,
      },
      'Operation': 'message_read',
    };

    _socket.send({
      'Data': data,
      'TicketToken': state.ticketToken,
      'Type': 'message',
    });
  }

  void _hideHints() {
    emit(
      state.copyWith(showHints: false),
    );
  }

  void requestStreamotionButton() {
    emit(
      state.copyWith(requestStreamotionButton: true),
    );
  }

  void _showStreamotionButton() {
    emit(
      state.copyWith(showStreamotionButton: true),
    );
  }

  void _hideStreamotionButton() {
    emit(
      state.copyWith(
        requestStreamotionButton: false,
        showStreamotionButton: false,
      ),
    );
  }

  Future<void> sendMessageText(
    String text,
  ) async {
    await FirebaseCrashlytics.instance.log('69ff1411: sendMessageText');

    if (text.isEmpty) {
      return;
    }

    final data = {
      'Operation': 'chat_new_message',
      'Object': {
        'Meta': [
          {'Body': text},
        ],
        if (state.isVoccentAI) 'VoccentAI': true,
      },
    };

    final map = await _socket.request(
      <String, dynamic>{
        'Data': data,
        'TicketToken': state.ticketToken,
        'Type': 'message',
      },
      'activity',
      state.operationId ?? '',
    );
    dynamic dataObject;
    if (map['Data'] is Map<String, dynamic>) {
      dataObject = map['Data'] as Map<String, dynamic>;
    }
    if (map['Data'] is String) {
      final jsonData = map['Data'] as String;
      dataObject = json.decode(jsonData) as Map<String, dynamic>;
    }
    dataObject as Map<String, dynamic>;

    switch (dataObject['Operation'] as String) {
      case 'chat_new_message':
        final message = Message.fromJson(
          dataObject['Object'] as Map<String, dynamic>,
        );

        final messages = List<Message>.from(
          state.messages,
        )..add(
            message,
          );
        if (state.isVoccentAI && message.createdby != voccentAiId) {
          emit(state.copyWith(isTyping: true));
        }
        emit(
          state.copyWith(
            messages: messages,
            query: '',
          ),
        );
    }
    if (state.showHints == true) {
      _hideHints();
    }
    if (state.showStreamotionButton == true) {
      _hideStreamotionButton();
    }
  }

  Future<void> deleteMessageText(String messageId) async {
    await FirebaseCrashlytics.instance.log('69ff1413: deleteMessageText');

    if (messageId.isEmpty) {
      return;
    }

    final data = {
      'Operation': 'chat_delete_message',
      'Object': {
        'ID': messageId,
      },
    };

    final map = await _socket.request(
      <String, dynamic>{
        'Data': data,
        'TicketToken': state.ticketToken,
        'Type': 'message',
      },
      'activity',
      state.operationId ?? '',
    );

    final dataObject = map['Data'] as Map<String, dynamic>;

    switch (dataObject['Operation'] as String) {
      case 'chat_delete_message':
        final messages = List<Message>.from(
          state.messages,
        );
        final deleteMetaObject = dataObject['Object'] as Map<String, dynamic>;
        final deleteId = deleteMetaObject['ID'] as String;
        messages.removeWhere((message) => message.id == deleteId);
        for (final message in messages) {
          message.meta.removeWhere((metaItem) => metaItem.id == deleteId);
        }
        emit(state.copyWith(messages: messages));
    }
  }

  void startEditingMessage({
    required String initialText,
    required String metaId,
    required String messageId,
  }) {
    emit(
      state.copyWith(
        isEditingMode: true,
        editingMessageId: messageId,
        editingMetaId: metaId,
        editingMessageText: initialText,
      ),
    );
  }

  void resetEditingMode() {
    emit(
      state.copyWith(
        isEditingMode: false,
        editingMessageId: '',
        editingMetaId: '',
        editingMessageText: '',
      ),
    );
  }

  Future<void> editMessageText(String newMessageText) async {
    await FirebaseCrashlytics.instance.log('69ff1414: editMessageText');

    final data = {
      'Operation': 'chat_update_message',
      'Object': {
        'Body': newMessageText,
        'ID': state.editingMetaId,
        'MessageID': state.editingMessageId,
      },
    };
    resetEditingMode();

    final map = await _socket.request(
      <String, dynamic>{
        'Data': data,
        'TicketToken': state.ticketToken,
        'Type': 'message',
      },
      'activity',
      state.operationId ?? '',
    );

    final dataObject = map['Data'] as Map<String, dynamic>;

    switch (dataObject['Operation'] as String) {
      case 'chat_update_message':
        final updatedMessageData = dataObject['Object'] as Map<String, dynamic>;
        final updateId = updatedMessageData['MessageID'] as String;
        final updatedMessages = List<Message>.from(state.messages);

        for (var i = 0; i < updatedMessages.length; i++) {
          if (updatedMessages[i].id == updateId) {
            final newMeta = Meta.fromJson(updatedMessageData);
            updatedMessages[i] = updatedMessages[i].copyWith(meta: [newMeta]);
            break;
          }
        }

        emit(state.copyWith(messages: updatedMessages));
    }
  }

  void changeNotificationSettings(MuteType muteType) {
    switch (muteType) {
      case MuteType.user:
        final data = {
          'Operation': 'change_mute',
          'Object': {
            'muteUser': !state.muteUser,
          },
        };

        _socket.send(
          <String, dynamic>{
            'Data': data,
            'TicketToken': state.ticketToken,
            'Type': 'message',
          },
        );
        emit(
          state.copyWith(
            muteUser: !state.muteUser,
          ),
        );
      case MuteType.author:
        final data = {
          'Operation': 'change_mute',
          'Object': {
            'muteAuthor': !state.muteAuthor,
          },
        };

        _socket.send(
          <String, dynamic>{
            'Data': data,
            'TicketToken': state.ticketToken,
            'Type': 'message',
          },
        );
        emit(
          state.copyWith(
            muteAuthor: !state.muteAuthor,
          ),
        );
    }
  }

  Future<String> _generateTicketToken(
    String ticket,
    String id,
  ) async {
    final map = await _socket.request(
      {
        'Token': await _userToken.value(),
        'Type': 'generate_ticket_token',
      },
      ticket,
      id,
    );

    if (map['Type'] == 'error') {
      throw Exception(map['Data']);
    }

    return map['TicketToken'] as String;
  }

  void _onWebSocketDone() {
    _socketSubscription.cancel();
  }

  Future<void> _onSocketEvent(EventType evt) async {
    switch (evt) {
      case EventType.connected:
        emit(
          state.copyWith(
            ticketToken: await _generateTicketToken(
              'activity',
              state.operationId ?? '',
            ),
          ),
        );
      case EventType.disconnected:
        break;
    }
  }

  void _onSocketEventsDone() {
    _socketEventsSubscription.cancel();
  }

  Future<void> _onWebSocketError(dynamic error) async {
    if (!kIsWeb) {
      await FirebaseCrashlytics.instance.recordError(error, StackTrace.current);
    }

    developer.log(error.toString(), name: 'ActivityChat');
  }

  @override
  Future<void> close() async {
    if (state.ticketToken != null) {
      _socket.send(
        <String, dynamic>{
          'TicketToken': state.ticketToken,
          'Type': 'remove_ticket_token',
        },
      );
    }
    await _socketSubscription.cancel();
    await _socketEventsSubscription.cancel();
    return super.close();
  }
}
