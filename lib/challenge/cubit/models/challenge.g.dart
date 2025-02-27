// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Challenge _$ChallengeFromJson(Map<String, dynamic> json) => Challenge(
      createdAt: json['createdat'] == null
          ? null
          : DateTime.parse(json['createdat'] as String),
      id: json['ID'] as String? ?? '',
      name: json['Name'] as String? ?? '',
      audioSampleRefID: json['AudioSampleRefID'] as String? ?? '',
      userName: json['UserName'] as String? ?? '',
      channelName: json['ChannelName'] as String? ?? '',
      channelId: json['ChannelID'] as String? ?? '',
      rating: (json['Rating'] as num?)?.toDouble() ?? 0,
      level: (json['Level'] as num?)?.toInt() ?? 50,
      mode: json['Mode'] as String? ?? '',
      asset: json['Asset'] as Map<String, dynamic>?,
      languageId: json['LanguageID'] as String?,
      spelling: json['Spelling'] as String?,
      isViewed: json['isViewed'] as bool? ?? false,
    );

Map<String, dynamic> _$ChallengeToJson(Challenge instance) => <String, dynamic>{
      'ID': instance.id,
      'Name': instance.name,
      'AudioSampleRefID': instance.audioSampleRefID,
      'UserName': instance.userName,
      'ChannelName': instance.channelName,
      'ChannelID': instance.channelId,
      'Mode': instance.mode,
      'Level': instance.level,
      'Rating': instance.rating,
      'createdat': instance.createdAt?.toIso8601String(),
      'Asset': instance.asset,
      'LanguageID': instance.languageId,
      'Spelling': instance.spelling,
      'isViewed': instance.isViewed,
    };
