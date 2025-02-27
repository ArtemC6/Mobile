// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'story_pass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryPass _$StoryPassFromJson(Map<String, dynamic> json) => StoryPass(
      id: json['ID'] as String?,
      link: json['Link'] as String?,
      storyId: json['StoryID'] as String?,
      storyParentId: json['StoryParentID'] as String?,
      status: json['Status'] as String?,
      actId: json['ActID'] as String?,
      actItemId: json['ActItemID'] as String?,
      condition: json['Condition'] as bool?,
      progress: (json['Progress'] as num?)?.toDouble() ?? 0,
      pause: json['Pause'] as bool?,
      type: (json['Type'] as num?)?.toInt(),
      levels: (json['Levels'] as num?)?.toInt(),
      actItemNumber: (json['ActItemNumber'] as num?)?.toInt(),
      actItems: (json['ActItems'] as num?)?.toInt(),
      progressAct: (json['ProgressAct'] as num?)?.toDouble(),
      levelNumber: (json['LevelNumber'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StoryPassToJson(StoryPass instance) => <String, dynamic>{
      'ID': instance.id,
      'Link': instance.link,
      'StoryID': instance.storyId,
      'StoryParentID': instance.storyParentId,
      'Status': instance.status,
      'ActID': instance.actId,
      'ActItemID': instance.actItemId,
      'Condition': instance.condition,
      'Progress': instance.progress,
      'Pause': instance.pause,
      'Type': instance.type,
      'Levels': instance.levels,
      'ActItemNumber': instance.actItemNumber,
      'ActItems': instance.actItems,
      'ProgressAct': instance.progressAct,
      'LevelNumber': instance.levelNumber,
    };
