// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asset _$AssetFromJson(Map<String, dynamic> json) => Asset(
      challengePicture: (json['challenge_picture'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      channelAvatar: (json['channel_avatar'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      channelBanner: (json['channel_banner'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'challenge_picture': instance.challengePicture,
      'channel_avatar': instance.channelAvatar,
      'channel_banner': instance.channelBanner,
    };
