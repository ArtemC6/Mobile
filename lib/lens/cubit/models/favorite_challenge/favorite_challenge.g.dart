// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'favorite_challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteChallenge _$FavoriteChallengeFromJson(Map<String, dynamic> json) =>
    FavoriteChallenge(
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
      rating: json['Rating'] as num?,
      sourceLanguageId: json['SourceLanguageID'] as String?,
      languageId: json['LanguageID'] as String?,
      difficulty: json['Difficulty'],
      views: (json['Views'] as num?)?.toInt(),
      channelId: json['ChannelID'] as String?,
      mode: json['Mode'] as String?,
      spelling: json['Spelling'] as String?,
      level: json['Level'],
      channelName: json['ChannelName'] as String?,
      channelCreatedBy: json['ChannelCreatedBy'] as String?,
      asset: json['Asset'] == null
          ? null
          : Asset.fromJson(json['Asset'] as Map<String, dynamic>),
      categories: json['Categories'],
      userName: json['UserName'] as String?,
      access: json['Access'] == null
          ? null
          : Access.fromJson(json['Access'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FavoriteChallengeToJson(FavoriteChallenge instance) =>
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
      'Rating': instance.rating,
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
      'Access': instance.access,
    };
