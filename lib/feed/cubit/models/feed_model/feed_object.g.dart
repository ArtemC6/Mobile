// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'feed_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedObject _$FeedObjectFromJson(Map<String, dynamic> json) => FeedObject(
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
      tags: json['Tags'],
      countRating: (json['CountRating'] as num?)?.toDouble(),
      rating: (json['Rating'] as num?)?.toDouble(),
      languageId: json['LanguageID'] as String?,
      difficulty: (json['Difficulty'] as num?)?.toInt(),
      views: json['Views'],
      channelId: json['ChannelID'] as String?,
      asset: json['Asset'] == null
          ? null
          : Asset.fromJson(json['Asset'] as Map<String, dynamic>),
      mode: json['Mode'] as String?,
      categories: json['Categories'],
      spelling: json['Spelling'],
      level: (json['Level'] as num?)?.toInt(),
      userName: json['UserName'] as String?,
      channelName: json['ChannelName'] as String?,
      channelCreatedBy: json['ChannelCreatedBy'] as String?,
      parentPrivacy: json['ParentPrivacy'] as String?,
      description: json['Description'] as String?,
      languageIds: (json['LanguageIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      pictureIdFirst: json['PictureIDFirst'] as String?,
      itemCount: (json['ItemCount'] as num?)?.toInt(),
      levels: (json['Levels'] as num?)?.toInt(),
      actItems: (json['ActItems'] as num?)?.toInt(),
      currentPass: json['CurrentPass'] == null
          ? null
          : StoryCurrentPass.fromJson(
              json['CurrentPass'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FeedObjectToJson(FeedObject instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'createdat': instance.createdat?.toIso8601String(),
      'updatedat': instance.updatedat?.toIso8601String(),
      'createdby': instance.createdby,
      'Name': instance.name,
      'AudioSampleRefID': instance.audioSampleRefId,
      'Privacy': instance.privacy,
      'Tags': instance.tags,
      'CountRating': instance.countRating,
      'Rating': instance.rating,
      'LanguageID': instance.languageId,
      'Difficulty': instance.difficulty,
      'Views': instance.views,
      'ChannelID': instance.channelId,
      'Asset': instance.asset,
      'Mode': instance.mode,
      'Categories': instance.categories,
      'Spelling': instance.spelling,
      'Level': instance.level,
      'UserName': instance.userName,
      'ChannelName': instance.channelName,
      'ChannelCreatedBy': instance.channelCreatedBy,
      'ParentPrivacy': instance.parentPrivacy,
      'Description': instance.description,
      'LanguageIDs': instance.languageIds,
      'PictureIDFirst': instance.pictureIdFirst,
      'ItemCount': instance.itemCount,
      'Levels': instance.levels,
      'ActItems': instance.actItems,
      'CurrentPass': instance.currentPass,
    };
