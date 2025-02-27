// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      createdBy: json['CreatedBy'] as String?,
      id: json['ID'] as String?,
      messageStatus: json['MessageStatus'] as String?,
      objectCtreatedBy: json['ObjectCtreatedBy'] as String?,
      objectId: json['ObjectID'] as String?,
      subjectName: json['SubjectName'] as String?,
      type: json['Type'] as String?,
      users: (json['Users'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'CreatedBy': instance.createdBy,
      'ID': instance.id,
      'MessageStatus': instance.messageStatus,
      'ObjectCtreatedBy': instance.objectCtreatedBy,
      'ObjectID': instance.objectId,
      'SubjectName': instance.subjectName,
      'Type': instance.type,
      'Users': instance.users,
    };
