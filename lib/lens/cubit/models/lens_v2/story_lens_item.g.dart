// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'story_lens_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryLensItem _$StoryLensItemFromJson(Map<String, dynamic> json) =>
    StoryLensItem(
      id: json['ID'] as String?,
      createdat: json['createdat'] == null
          ? null
          : DateTime.parse(json['createdat'] as String),
      updatedat: json['updatedat'] == null
          ? null
          : DateTime.parse(json['updatedat'] as String),
      createdby: json['createdby'] as String?,
      updatedby: json['updatedby'] as String?,
      organizationId: json['OrganizationID'],
      showForAll: json['ShowForAll'] as bool?,
      channelId: json['ChannelID'] as String?,
      channelName: json['ChannelName'] as String?,
      channelCreatedBy: json['ChannelCreatedBy'] as String?,
      name: json['Name'] as String?,
      description: json['Description'],
      privacy: json['Privacy'] as String?,
      level: (json['Level'] as num?)?.toInt(),
      levels: (json['Levels'] as num?)?.toInt(),
      acts: (json['Acts'] as num?)?.toInt(),
      actItems: (json['ActItems'] as num?)?.toInt(),
      countRating: json['CountRating'],
      rating: json['Rating'],
      sourceLanguageId: json['SourceLanguageID'] as String?,
      onboarding: json['Onboarding'] as bool?,
      istemplate: json['Istemplate'] as bool?,
      userName: json['UserName'] as String?,
    );

Map<String, dynamic> _$StoryLensItemToJson(StoryLensItem instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'createdat': instance.createdat?.toIso8601String(),
      'updatedat': instance.updatedat?.toIso8601String(),
      'createdby': instance.createdby,
      'updatedby': instance.updatedby,
      'OrganizationID': instance.organizationId,
      'ShowForAll': instance.showForAll,
      'ChannelID': instance.channelId,
      'ChannelName': instance.channelName,
      'ChannelCreatedBy': instance.channelCreatedBy,
      'Name': instance.name,
      'Description': instance.description,
      'Privacy': instance.privacy,
      'Level': instance.level,
      'Levels': instance.levels,
      'Acts': instance.acts,
      'ActItems': instance.actItems,
      'CountRating': instance.countRating,
      'Rating': instance.rating,
      'SourceLanguageID': instance.sourceLanguageId,
      'Onboarding': instance.onboarding,
      'Istemplate': instance.istemplate,
      'UserName': instance.userName,
    };
