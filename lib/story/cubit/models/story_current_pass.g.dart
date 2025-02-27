// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'story_current_pass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryCurrentPass _$StoryCurrentPassFromJson(Map<String, dynamic> json) =>
    StoryCurrentPass(
      actAudiosampleRefId: json['ActAudiosamplerefid'] as String?,
      actBackgroundAudiosampleRefId:
          json['ActBackgroundAudiosamplerefid'] as String?,
      actConditions: (json['ActConditions'] as List<dynamic>?)
          ?.map((e) => Condition.fromJson(e as Map<String, dynamic>))
          .toList(),
      actDescription: json['ActDescription'] as String?,
      actId: json['ActID'] as String?,
      actName: json['ActName'] as String?,
      itemAudiosamplerefid: json['ItemAudiosamplerefid'] as String?,
      itemVideosamplerefid: json['ItemVideosamplerefid'] as String?,
      itemCharacterID: json['ItemCharacterID'] as String?,
      itemCharacterName: json['ItemCharacterName'] as String?,
      itemId: json['ItemID'] as String?,
      itemLanguageId: json['ItemLanguageID'] as String?,
      itemUserAudiosamplerefid: json['ItemUserAudiosamplerefid'] as String?,
      itemPassAudiosamplerefid: json['ItemPassAudiosamplerefid'] as String?,
      itemPassID: json['ItemPassID'] as String?,
      itemSpelling: json['ItemSpelling'] as String?,
      userId: json['UserID'] as String?,
      userName: json['UserName'] as String?,
      itemType: (json['ItemType'] as num?)?.toInt(),
      comparePercent: (json['ComparePercent'] as num?)?.toDouble(),
      itemPassQuiz: json['ItemPassQuiz'] == null
          ? null
          : ItemPassQuiz.fromJson(json['ItemPassQuiz'] as Map<String, dynamic>),
      itemQuizCount: (json['ItemQuizCount'] as num?)?.toInt(),
      itemQuizList: (json['ItemQuizList'] as List<dynamic>?)
          ?.map((e) => ItemQuizList.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemQuizMultiple: json['ItemQuizMultiple'] as bool?,
      itemQuizType: (json['ItemQuizType'] as num?)?.toInt(),
      itemPassPause: (json['ItemPassPause'] as num?)?.toInt(),
      itemMessage: json['ItemMessage'] as String?,
      autoShow: json['AutoShow'] as bool?,
      itemRecordDuration: (json['ItemRecordDuration'] as num?)?.toInt(),
      itemVideoStart: (json['ItemVideoStart'] as num?)?.toInt(),
      itemVideoEnd: (json['ItemVideoEnd'] as num?)?.toInt(),
      itemVideoLoop: json['ItemVideoLoop'] as bool?,
      itemVideoControls: json['ItemVideoControls'] as bool?,
      itemVisualType: (json['ItemVisualType'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StoryCurrentPassToJson(StoryCurrentPass instance) =>
    <String, dynamic>{
      'ActAudiosamplerefid': instance.actAudiosampleRefId,
      'ActBackgroundAudiosamplerefid': instance.actBackgroundAudiosampleRefId,
      'ActConditions': instance.actConditions,
      'ActDescription': instance.actDescription,
      'ActID': instance.actId,
      'ActName': instance.actName,
      'ComparePercent': instance.comparePercent,
      'ItemAudiosamplerefid': instance.itemAudiosamplerefid,
      'ItemVideosamplerefid': instance.itemVideosamplerefid,
      'ItemCharacterID': instance.itemCharacterID,
      'ItemCharacterName': instance.itemCharacterName,
      'ItemID': instance.itemId,
      'ItemLanguageID': instance.itemLanguageId,
      'ItemUserAudiosamplerefid': instance.itemUserAudiosamplerefid,
      'ItemPassAudiosamplerefid': instance.itemPassAudiosamplerefid,
      'ItemPassID': instance.itemPassID,
      'ItemPassQuiz': instance.itemPassQuiz,
      'ItemQuizCount': instance.itemQuizCount,
      'ItemPassPause': instance.itemPassPause,
      'ItemQuizList': instance.itemQuizList,
      'ItemQuizMultiple': instance.itemQuizMultiple,
      'ItemQuizType': instance.itemQuizType,
      'ItemSpelling': instance.itemSpelling,
      'UserID': instance.userId,
      'UserName': instance.userName,
      'ItemType': instance.itemType,
      'ItemMessage': instance.itemMessage,
      'AutoShow': instance.autoShow,
      'ItemRecordDuration': instance.itemRecordDuration,
      'ItemVideoStart': instance.itemVideoStart,
      'ItemVideoEnd': instance.itemVideoEnd,
      'ItemVideoLoop': instance.itemVideoLoop,
      'ItemVideoControls': instance.itemVideoControls,
      'ItemVisualType': instance.itemVisualType,
    };
