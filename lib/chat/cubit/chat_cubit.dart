import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:voccent/chat/cubit/models/chat/chat.dart';
import 'package:voccent/chat/cubit/models/message/message.dart';
import 'package:voccent/chat/cubit/models/message/meta.dart';
import 'package:voccent/home/cubit/models/user/user.dart';
import 'package:voccent/http/response_data.dart';
import 'package:voccent/http/user_token.dart';
import 'package:voccent/web_socket/web_socket.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._client, this._socket, this._userToken)
      : super(
          const ChatState(
            user: User(),
            chats: [],
            messages: [],
          ),
        ) {
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

  final UserToken _userToken;
  final Client _client;
  final WebSocket _socket;
  late StreamSubscription<Map<String, dynamic>> _socketSubscription;
  late StreamSubscription<EventType> _socketEventsSubscription;

  Future<String> writeToAuthor(String channelId) async {
    final response = await _client.post(
      Uri.parse(
        '/api/v1/chat/channel_author/$channelId',
      ),
      body: jsonEncode({
        'Meta': [
          {'Body': 'Started conversation'},
        ],
      }),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    ).mapData();

    return response['ID'] as String;
  }

  Future<void> init(User user) async {
    await FirebaseCrashlytics.instance.log('9bc82e44: `${user.credId}`');
    if (user.credId == null) {
      return;
    }

    emit(state.copyWith(uiLoading: true));

    final chats = await _loadChatsWithSort(user);

    emit(
      state.copyWith(
        user: user,
        chats: chats,
        uiLoading: false,
      ),
    );

    if (!kIsWeb) {
      Pushy.clearBadge();
    }

    await FirebaseCrashlytics.instance.log('ea4d2526: genereting ticket token'
        ' `inbox_chat_user` `${user.id}`');

    emit(
      state.copyWith(
        inboxChatUserToken: await _generateTicketToken(
          'inbox_chat_user',
          user.id!,
        ),
      ),
    );

    await FirebaseCrashlytics.instance.log('7d5b10a1: ticket token generated'
        ' `inbox_chat_user` `${user.id}` `${state.inboxChatUserToken}`');

    _socket.send(
      <String, dynamic>{
        'Token': await _userToken.value(),
        'Type': 'connect',
      },
    );
  }

  Future<List<Chat>> _loadChatsWithSort(User user) async {
    await FirebaseCrashlytics.instance
        .log('0fb5290a: loading chats `${user.id}`');

    final chats = (await _client.get(Uri.parse('/api/v1/chat/list')).listData())
        .map((dynamic e) {
      final chat = Chat.fromJson(e as Map<String, dynamic>);

      // don't show current user's name in list of users
      chat.users?.removeWhere((element) => element.id == user.id);

      return chat;
    }).toList();

    // 'system_personal' chat should not be null
    final systemChat =
        chats.firstWhere((element) => element.type == 'system_personal');
    final chatsSorted = chats
      ..sort((a, b) => a.messageStatus == 'new' ? -1 : 1)
      ..removeWhere((element) => element.id == systemChat.id)
      ..insert(0, systemChat);

    await FirebaseCrashlytics.instance
        .log('d5e29a08: chats loaded `${user.id}`');

    return chatsSorted;
  }

  Future<void> openChat(String chatId) async {
    if (chatId == state.currentChat?.id) {
      await FirebaseCrashlytics.instance
          .log('ca08a165: tried to open current chat `$chatId`');
      return;
    }

    if (!state.chats.any((element) => element.id == chatId)) {
      emit(state.copyWith(chats: await _loadChatsWithSort(state.user)));
    }

    final chat = state.chats.firstWhere((element) => element.id == chatId);

    await _loadMessages(chat);
  }

  Future<void> _loadMessages(Chat chat) async {
    if (chat.id == state.currentChat?.id) {
      await FirebaseCrashlytics.instance
          .log('cde9eed8: tried to load current chat messages `${chat.id}`');
      return;
    }

    emit(state.copyWith(uiLoading: true, currentChat: chat));

    await FirebaseCrashlytics.instance
        .log('51bc35a8: requesting messages `${chat.id}`');

    final messages = (await _client
            .get(Uri.parse('/api/v1/chat/messages/${chat.id!}'))
            .listData())
        .map((dynamic e) => Message.fromJson(e as Map<String, dynamic>));

    await FirebaseCrashlytics.instance
        .log('b4ac2040: generating `inbox_chat_messages` `${chat.id}`');

    final inboxChatMessagesToken = await _generateTicketToken(
      'inbox_chat_messages',
      chat.id!,
    );

    await FirebaseCrashlytics.instance
        .log('51654a8b: generated `inbox_chat_messages` '
            '`$inboxChatMessagesToken`');

    emit(
      state.copyWith(
        uiLoading: false,
        messages: messages.toList(),
        inboxChatMessagesToken: inboxChatMessagesToken,
      ),
    );

    // Mark chat as read
    _socket.send(
      <String, dynamic>{
        'Data': <String, dynamic>{
          'ChatID': chat.id,
          'Status': 'read',
        },
        'TicketToken': state.inboxChatUserToken,
        'Type': 'message',
      },
    );
  }

  Future<void> _onData(Map<String, dynamic> frame) async {
    // if chat is not responding revert me
    if (frame['OperationID'] != state.currentChat?.id &&
            frame['OperationID'] != state.user.id ||
        !frame['Ticket'].toString().contains('chat')) {
      return;
    }

    log(frame.toString(), name: 'Chat');

    if (frame['Data'] == null) {
      return;
    }

    if (frame['Type'] == 'error' && !kIsWeb) {
      await FirebaseCrashlytics.instance.recordError(frame, StackTrace.current);

      return;
    }

    final Map<String, dynamic> dataObject;

    if (frame['Data'] is Map<String, dynamic>) {
      dataObject = frame['Data'] as Map<String, dynamic>;
    } else if (frame['Data'] is String) {
      dataObject = jsonDecode(frame['Data'] as String) as Map<String, dynamic>;
    } else {
      throw Exception('a6acd510: Unexpected WS frame');
    }

    if (frame['Ticket'] == 'inbox_chat_messages' &&
        frame['Type'] == 'message' &&
        frame['OperationID'] == state.currentChat?.id) {
      switch (dataObject['Operation'] as String) {
        case 'new_message':
          final message = Message.fromJson(
            dataObject['Object'] as Map<String, dynamic>,
          );

          final messages = List<Message>.from(
            state.messages,
          )..add(
              message,
            );

          emit(state.copyWith(messages: messages));

        case 'delete_message_meta':
          final messages = List<Message>.from(
            state.messages,
          );
          final deleteMetaObject = dataObject['Object'] as Map<String, dynamic>;

          for (var i = 0; i < messages.length; i++) {
            if (messages[i].id == deleteMetaObject['MessageID']) {
              if (messages[i].meta.isNotEmpty) {
                for (var j = 0; j < messages[i].meta.length; j++) {
                  if (messages[i].meta[j].id ==
                      deleteMetaObject['MessageMetaID']) {
                    messages[i].meta.removeAt(j);
                  }
                }
              }
              break;
            }
          }
          emit(state.copyWith(messages: messages));
      }
    }

    if (frame['Ticket'] == 'inbox_chat_user' && frame['Type'] == 'message') {
      if (dataObject['MessageStatus'] == 'new' &&
          dataObject['ID'] == state.currentChat?.id) {
        return;
      }

      var chats = List<Chat>.from(state.chats);
      if (!chats.any((element) => element.id == dataObject['ID'])) {
        chats = await _loadChatsWithSort(state.user);
      }

      if (!chats.any((element) => element.id == dataObject['ID'])) {
        log('warning-815796d3: unknown chat id', name: 'Chat');

        return;
      }

      emit(state.copyWith(chats: []));

      // 'system_personal' chat should not be null
      final systemChat =
          chats.firstWhere((element) => element.type == 'system_personal');
      chats
        ..firstWhere((element) => element.id == dataObject['ID'])
            .messageStatus = dataObject['MessageStatus'] as String
        ..sort((a, b) => a.messageStatus == 'new' ? -1 : 1)
        ..removeWhere((element) => element.id == systemChat.id)
        ..insert(0, systemChat);

      emit(state.copyWith(chats: chats));
    }
  }

  void _onDone() {
    _socketSubscription.cancel();
  }

  Future<void> _onError(dynamic error) async {
    if (!kIsWeb) {
      await FirebaseCrashlytics.instance.recordError(error, StackTrace.current);
    }

    log(error.toString(), name: 'Chat');
  }

  Future<void> _onSocketEvent(EventType evt) async {
    switch (evt) {
      case EventType.connected:
        await FirebaseCrashlytics.instance.log('d5c77f6e: WS status connected');

        _socket.send(
          <String, dynamic>{
            'Token': await _userToken.value(),
            'Type': 'connect',
          },
        );
        emit(
          state.copyWith(
            inboxChatUserToken: state.user.id != null
                ? await _generateTicketToken(
                    'inbox_chat_user',
                    state.user.id!,
                  )
                : null,
            inboxChatMessagesToken: state.currentChat?.id != null
                ? await _generateTicketToken(
                    'inbox_chat_messages',
                    state.currentChat!.id!,
                  )
                : null,
          ),
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

  void resetMessages() {
    FirebaseCrashlytics.instance.log('f411d1a8: remove_ticket_token and chat'
        ' `${state.inboxChatMessagesToken}`');

    _socket.send(
      <String, dynamic>{
        'TicketToken': state.inboxChatMessagesToken,
        'Type': 'remove_ticket_token',
      },
    );

    emit(
      state.copyWith(
        nullChat: true,
        nullInboxChatMessagesToken: true,
      ),
    );
  }

  Future<void> sendMessageText(String text) async {
    await FirebaseCrashlytics.instance.log('69ff1411: sendMessageText');

    if (text.isEmpty) {
      return;
    }

    final data = {
      'Operation': 'new_message',
      'Object': {
        'Meta': [
          {'Body': text},
        ],
      },
    };

    final map = await _socket.request(
      <String, dynamic>{
        'Data': data,
        'TicketToken': state.inboxChatMessagesToken,
        'Type': 'message',
      },
      'inbox_chat_messages',
      state.currentChat!.id!,
    );

    final dataObject = map['Data'] as Map<String, dynamic>;

    switch (dataObject['Operation'] as String) {
      case 'new_message':
        final message = Message.fromJson(
          dataObject['Object'] as Map<String, dynamic>,
        );

        final messages = List<Message>.from(
          state.messages,
        )..add(
            message,
          );

        emit(state.copyWith(messages: messages));

      case 'delete_message_meta':
        final messages = List<Message>.from(
          state.messages,
        );
        final deleteMetaObject = dataObject['Object'] as Map<String, dynamic>;

        for (var i = 0; i < messages.length; i++) {
          if (messages[i].id == deleteMetaObject['MessageID']) {
            if (messages[i].meta.isNotEmpty) {
              for (var j = 0; j < messages[i].meta.length; j++) {
                if (messages[i].meta[j].id ==
                    deleteMetaObject['MessageMetaID']) {
                  messages[i].meta.removeAt(j);
                }
              }
            }
            break;
          }
        }
        emit(state.copyWith(messages: messages));
    }
  }

  // ignore: avoid_positional_boolean_parameters
  void joinConfirmOrCancel(Meta meta, bool confirm) {
    var objName = 'campus';
    if (meta.type == 'invitation_campus') {
      objName = 'campus';
    } else if (meta.type == 'invitation_classroom') {
      objName = 'classroom';
    }

    _client.post(
      Uri.parse(
        '/api/v1/$objName/${confirm ? 'confirm' : 'cancel'}_join/${meta.objectId}',
      ),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: meta.objectId,
    );
  }

  @override
  Future<void> close() async {
    await _socketSubscription.cancel();
    await _socketEventsSubscription.cancel();
    return super.close();
  }
}
