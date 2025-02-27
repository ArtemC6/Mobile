part of 'activity_chat_cubit.dart';

enum Status { initial, loading, ready }

enum MuteType { user, author }

class ActivityChatState extends Equatable {
  const ActivityChatState({
    required this.user,
    required this.messages,
    this.status = Status.initial,
    this.ticketToken,
    this.operationId,
    this.isEditingMode = false,
    this.editingMessageId,
    this.editingMetaId,
    this.editingMessageText,
    this.usersOnline = const [],
    this.chatId,
    this.lastId = '',
    this.hasReachedMax = false,
    this.isVoccentAI = false,
    this.isTyping = false,
    this.query = '',
    this.showHints = true,
    this.showStreamotionButton = false,
    this.requestStreamotionButton = false,
    this.chatUser,
    this.muteUser = false,
    this.muteAuthor = false,
    this.orderAsc = false,
    this.orderDesc = true,
    this.newMessageID = '',
  });
  final User user;
  final List<Message> messages;
  final Status status;
  final String? ticketToken;
  final String? operationId;
  final bool isEditingMode;
  final String? editingMessageId;
  final String? editingMetaId;
  final String? editingMessageText;
  final List<User> usersOnline;
  final String? chatId;
  final String lastId;
  final bool hasReachedMax;
  final bool isVoccentAI;
  final bool isTyping;
  final String query;
  final bool showHints;
  final bool showStreamotionButton;
  final bool requestStreamotionButton;
  final ChatUser? chatUser;
  final bool muteUser;
  final bool muteAuthor;
  final bool orderDesc;
  final bool orderAsc;
  final String newMessageID;

  ActivityChatState copyWith({
    User? user,
    List<Message>? messages,
    Status? status,
    String? ticketToken,
    String? operationId,
    bool? isEditingMode,
    String? editingMessageId,
    String? editingMetaId,
    String? editingMessageText,
    List<User>? usersOnline,
    String? chatId,
    String? lastId,
    bool? hasReachedMax,
    bool? isVoccentAI,
    bool? isTyping,
    String? query,
    bool? showHints,
    bool? showStreamotionButton,
    bool? requestStreamotionButton,
    ChatUser? chatUser,
    bool? muteUser,
    bool? muteAuthor,
    bool? orderDesc,
    bool? orderAsc,
    String? newMessageID,
  }) {
    return ActivityChatState(
      user: user ?? this.user,
      messages: messages ?? this.messages,
      status: status ?? this.status,
      ticketToken: ticketToken ?? this.ticketToken,
      operationId: operationId ?? this.operationId,
      isEditingMode: isEditingMode ?? this.isEditingMode,
      editingMessageId: editingMessageId ?? this.editingMessageId,
      editingMetaId: editingMetaId ?? this.editingMetaId,
      editingMessageText: editingMessageText ?? this.editingMessageText,
      usersOnline: usersOnline ?? this.usersOnline,
      chatId: chatId ?? this.chatId,
      lastId: lastId ?? this.lastId,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isVoccentAI: isVoccentAI ?? this.isVoccentAI,
      isTyping: isTyping ?? this.isTyping,
      query: query ?? this.query,
      showHints: showHints ?? this.showHints,
      showStreamotionButton:
          showStreamotionButton ?? this.showStreamotionButton,
      requestStreamotionButton:
          requestStreamotionButton ?? this.requestStreamotionButton,
      chatUser: chatUser ?? this.chatUser,
      muteAuthor: muteAuthor ?? this.muteAuthor,
      muteUser: muteUser ?? this.muteUser,
      orderDesc: orderDesc ?? this.orderDesc,
      orderAsc: orderAsc ?? this.orderAsc,
      newMessageID: newMessageID ?? this.newMessageID,
    );
  }

  @override
  List<Object?> get props => [
        user,
        messages,
        status,
        ticketToken,
        operationId,
        isEditingMode,
        editingMessageId,
        editingMetaId,
        editingMessageText,
        usersOnline,
        chatId,
        lastId,
        hasReachedMax,
        isTyping,
        query,
        showHints,
        showStreamotionButton,
        requestStreamotionButton,
        chatUser,
        muteUser,
        muteAuthor,
        orderDesc,
        orderAsc,
        newMessageID,
      ];
}
