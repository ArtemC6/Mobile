// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewNotification _$NewNotificationFromJson(Map<String, dynamic> json) =>
    NewNotification(
      chatId: json['ChatID'] as String?,
      createdAt: json['CreatedAt'] == null
          ? null
          : DateTime.parse(json['CreatedAt'] as String),
      id: json['ID'] as String?,
      message: json['Message'] as String?,
      objectId: json['ObjectID'] as String?,
      objectName: json['ObjectName'] as String?,
      objectType: json['ObjectType'] as String?,
      objectTypeName: json['ObjectTypeName'] as String?,
      userId: json['UserID'] as String?,
      userName: json['UserName'] as String?,
    );

Map<String, dynamic> _$NewNotificationToJson(NewNotification instance) =>
    <String, dynamic>{
      'ChatID': instance.chatId,
      'CreatedAt': instance.createdAt?.toIso8601String(),
      'ID': instance.id,
      'Message': instance.message,
      'ObjectID': instance.objectId,
      'ObjectName': instance.objectName,
      'ObjectType': instance.objectType,
      'ObjectTypeName': instance.objectTypeName,
      'UserID': instance.userId,
      'UserName': instance.userName,
    };
