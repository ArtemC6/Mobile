// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      id: json['ID'] as String?,
      body: json['Body'] as String?,
      chatId: json['ChatID'] as String?,
      messageId: json['MessageID'] as String?,
      objectId: json['ObjectID'] as String?,
      orderNum: (json['OrderNum'] as num?)?.toInt(),
      type: json['Type'] as String?,
      payload: json['Payload'] as String?,
      updatedAt: json['updatedat'] as String?,
      updatedBy: json['updatedby'] as String?,
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'ID': instance.id,
      'Body': instance.body,
      'ChatID': instance.chatId,
      'MessageID': instance.messageId,
      'ObjectID': instance.objectId,
      'OrderNum': instance.orderNum,
      'Type': instance.type,
      'Payload': instance.payload,
      'updatedat': instance.updatedAt,
      'updatedby': instance.updatedBy,
    };
