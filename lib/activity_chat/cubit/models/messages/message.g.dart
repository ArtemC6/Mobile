// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['ID'] as String?,
      createdat: json['createdat'] as String?,
      createdby: json['createdby'] as String?,
      username: json['Username'] as String?,
      meta: (json['Meta'] as List<dynamic>?)
              ?.map((e) => Meta.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'ID': instance.id,
      'createdat': instance.createdat,
      'createdby': instance.createdby,
      'Username': instance.username,
      'Meta': instance.meta,
    };
