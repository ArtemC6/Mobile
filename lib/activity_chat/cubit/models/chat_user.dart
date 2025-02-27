import 'package:json_annotation/json_annotation.dart';

part 'chat_user.g.dart';

@JsonSerializable()
class ChatUser {
  ChatUser({
    required this.status,
    required this.statusDate,
    required this.muteAll,
    required this.muteAuthor,
    required this.muteUser,
    this.newMessageID,
    this.newMessageDate,
    this.lastNewMessageID,
    this.lastNewMessageBody,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) =>
      _$ChatUserFromJson(json);

  @JsonKey(name: 'Status')
  final String? status;

  @JsonKey(
    name: 'StatusDate',
    fromJson: _fromJsonDateTime,
    toJson: _toJsonDateTime,
  )
  final DateTime? statusDate;

  @JsonKey(name: 'MuteAll')
  final bool? muteAll;

  @JsonKey(name: 'MuteAuthor')
  final bool? muteAuthor;

  @JsonKey(name: 'MuteUser')
  final bool? muteUser;

  @JsonKey(name: 'NewMessageID')
  final String? newMessageID;

  @JsonKey(
    name: 'NewMessageDate',
    fromJson: _fromJsonDateTime,
    toJson: _toJsonDateTime,
  )
  final DateTime? newMessageDate;

  @JsonKey(name: 'LastNewMessageID')
  final String? lastNewMessageID;

  @JsonKey(name: 'LastNewMessageBody')
  final String? lastNewMessageBody;

  Map<String, dynamic> toJson() => _$ChatUserToJson(this);

  ChatUser copyWith({
    String? status,
    DateTime? statusDate,
    bool? muteAll,
    bool? muteAuthor,
    bool? muteUser,
    String? newMessageID,
    DateTime? newMessageDate,
    String? lastNewMessageID,
    String? lastNewMessageBody,
  }) {
    return ChatUser(
      status: status ?? this.status,
      statusDate: statusDate ?? this.statusDate,
      muteAll: muteAll ?? this.muteAll,
      muteAuthor: muteAuthor ?? this.muteAuthor,
      muteUser: muteUser ?? this.muteUser,
      newMessageID: newMessageID ?? this.newMessageID,
      newMessageDate: newMessageDate ?? this.newMessageDate,
      lastNewMessageID: lastNewMessageID ?? this.lastNewMessageID,
      lastNewMessageBody: lastNewMessageBody ?? this.lastNewMessageBody,
    );
  }

  static DateTime? _fromJsonDateTime(String? jsonDate) =>
      jsonDate == null ? null : DateTime.parse(jsonDate);
  static String? _toJsonDateTime(DateTime? dateTime) =>
      dateTime?.toIso8601String();
}
