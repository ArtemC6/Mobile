part of 'chat_cubit.dart';

class ChatState extends Equatable {
  const ChatState({
    required this.user,
    required this.chats,
    required this.messages,
    this.uiLoading = false,
    this.currentChat,
    this.inboxChatUserToken,
    this.inboxChatMessagesToken,
  });

  final User user;
  final bool uiLoading;
  final List<Chat> chats;
  final Chat? currentChat;
  final List<Message> messages;
  final String? inboxChatUserToken;
  final String? inboxChatMessagesToken;

  ChatState copyWith({
    User? user,
    bool? uiLoading,
    Chat? currentChat,
    bool? nullChat,
    List<Chat>? chats,
    List<Message>? messages,
    bool? nullInboxChatUserToken,
    String? inboxChatUserToken,
    bool? nullInboxChatMessagesToken,
    String? inboxChatMessagesToken,
  }) {
    return ChatState(
      user: user ?? this.user,
      uiLoading: uiLoading ?? this.uiLoading,
      currentChat:
          (nullChat ?? false) ? null : (currentChat ?? this.currentChat),
      chats: chats ?? this.chats,
      messages: messages ?? this.messages,
      inboxChatUserToken: (nullInboxChatUserToken ?? false)
          ? null
          : (inboxChatUserToken ?? this.inboxChatUserToken),
      inboxChatMessagesToken: (nullInboxChatMessagesToken ?? false)
          ? null
          : (inboxChatMessagesToken ?? this.inboxChatMessagesToken),
    );
  }

  @override
  List<Object?> get props => [
        user,
        currentChat,
        chats,
        messages,
        uiLoading,
        inboxChatUserToken,
        inboxChatMessagesToken,
      ];
}
