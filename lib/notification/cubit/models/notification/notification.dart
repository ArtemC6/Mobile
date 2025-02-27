import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class NewNotification {
  NewNotification({
    this.chatId,
    this.createdAt,
    this.id,
    this.message,
    this.objectId,
    this.objectName,
    this.objectType,
    this.objectTypeName,
    this.userId,
    this.userName,
  });

  factory NewNotification.fromJson(Map<String, dynamic> json) {
    return _$NewNotificationFromJson(json);
  }
  @JsonKey(name: 'ChatID')
  String? chatId;
  @JsonKey(name: 'CreatedAt')
  DateTime? createdAt;
  @JsonKey(name: 'ID')
  String? id;
  @JsonKey(name: 'Message')
  String? message;
  @JsonKey(name: 'ObjectID')
  String? objectId;
  @JsonKey(name: 'ObjectName')
  String? objectName;
  @JsonKey(name: 'ObjectType')
  String? objectType;
  @JsonKey(name: 'ObjectTypeName')
  String? objectTypeName;
  @JsonKey(name: 'UserID')
  String? userId;
  @JsonKey(name: 'UserName')
  String? userName;

  Map<String, dynamic> toJson() => _$NewNotificationToJson(this);
}
