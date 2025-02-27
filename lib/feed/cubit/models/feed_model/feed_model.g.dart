// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'feed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedModel _$FeedModelFromJson(Map<String, dynamic> json) => FeedModel(
      id: json['ID'] as String?,
      type: json['Type'] as String?,
      createdBy: json['CreatedBy'] as String?,
      sourceLanguageGroup: (json['SourceLanguageGroup'] as num?)?.toInt(),
      object: json['Object'] == null
          ? null
          : FeedObject.fromJson(json['Object'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FeedModelToJson(FeedModel instance) => <String, dynamic>{
      'ID': instance.id,
      'Type': instance.type,
      'CreatedBy': instance.createdBy,
      'SourceLanguageGroup': instance.sourceLanguageGroup,
      'Object': instance.object,
    };
