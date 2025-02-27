// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'chat_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUser _$ChatUserFromJson(Map<String, dynamic> json) => ChatUser(
      status: json['Status'] as String?,
      statusDate: ChatUser._fromJsonDateTime(json['StatusDate'] as String?),
      muteAll: json['MuteAll'] as bool?,
      muteAuthor: json['MuteAuthor'] as bool?,
      muteUser: json['MuteUser'] as bool?,
      newMessageID: json['NewMessageID'] as String?,
      newMessageDate:
          ChatUser._fromJsonDateTime(json['NewMessageDate'] as String?),
      lastNewMessageID: json['LastNewMessageID'] as String?,
      lastNewMessageBody: json['LastNewMessageBody'] as String?,
    );

Map<String, dynamic> _$ChatUserToJson(ChatUser instance) => <String, dynamic>{
      'Status': instance.status,
      'StatusDate': ChatUser._toJsonDateTime(instance.statusDate),
      'MuteAll': instance.muteAll,
      'MuteAuthor': instance.muteAuthor,
      'MuteUser': instance.muteUser,
      'NewMessageID': instance.newMessageID,
      'NewMessageDate': ChatUser._toJsonDateTime(instance.newMessageDate),
      'LastNewMessageID': instance.lastNewMessageID,
      'LastNewMessageBody': instance.lastNewMessageBody,
    };
