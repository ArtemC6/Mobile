// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'challenge_lens_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeLensItem _$ChallengeLensItemFromJson(Map<String, dynamic> json) =>
    ChallengeLensItem(
      id: json['ID'] as String?,
      createdat: json['createdat'] == null
          ? null
          : DateTime.parse(json['createdat'] as String),
      updatedat: json['updatedat'] == null
          ? null
          : DateTime.parse(json['updatedat'] as String),
      createdby: json['createdby'] as String?,
      name: json['Name'] as String?,
      audioSampleRefId: json['AudioSampleRefID'] as String?,
      privacy: json['Privacy'] as String?,
      organizationId: json['OrganizationID'],
      showForAll: json['ShowForAll'] as bool?,
      countRating: (json['CountRating'] as num?)?.toInt(),
      sourceLanguageId: json['SourceLanguageID'] as String?,
      languageId: json['LanguageID'] as String?,
      difficulty: (json['Difficulty'] as num?)?.toInt(),
      views: (json['Views'] as num?)?.toInt(),
      channelId: json['ChannelID'] as String?,
      mode: json['Mode'] as String?,
      spelling: json['Spelling'] as String?,
      level: (json['Level'] as num?)?.toInt(),
      channelName: json['ChannelName'] as String?,
      channelCreatedBy: json['ChannelCreatedBy'] as String?,
      asset: json['Asset'],
      categories: json['Categories'],
      userName: json['UserName'] as String?,
    );

Map<String, dynamic> _$ChallengeLensItemToJson(ChallengeLensItem instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'createdat': instance.createdat?.toIso8601String(),
      'updatedat': instance.updatedat?.toIso8601String(),
      'createdby': instance.createdby,
      'Name': instance.name,
      'AudioSampleRefID': instance.audioSampleRefId,
      'Privacy': instance.privacy,
      'OrganizationID': instance.organizationId,
      'ShowForAll': instance.showForAll,
      'CountRating': instance.countRating,
      'SourceLanguageID': instance.sourceLanguageId,
      'LanguageID': instance.languageId,
      'Difficulty': instance.difficulty,
      'Views': instance.views,
      'ChannelID': instance.channelId,
      'Mode': instance.mode,
      'Spelling': instance.spelling,
      'Level': instance.level,
      'ChannelName': instance.channelName,
      'ChannelCreatedBy': instance.channelCreatedBy,
      'Asset': instance.asset,
      'Categories': instance.categories,
      'UserName': instance.userName,
    };
