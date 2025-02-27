// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'story_mode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryMode _$StoryModeFromJson(Map<String, dynamic> json) => StoryMode(
      id: json['ID'] as String,
      type: (json['Type'] as num).toInt(),
    );

Map<String, dynamic> _$StoryModeToJson(StoryMode instance) => <String, dynamic>{
      'ID': instance.id,
      'Type': instance.type,
    };
