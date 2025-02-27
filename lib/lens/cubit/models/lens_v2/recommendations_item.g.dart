// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'recommendations_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendationsItem _$RecommendationsItemFromJson(Map<String, dynamic> json) =>
    RecommendationsItem(
      objectId: json['ObjectID'] as String?,
      objectType: json['ObjectType'] as String?,
      challengeLensItem: json['Challenge'] == null
          ? null
          : ChallengeLensItem.fromJson(
              json['Challenge'] as Map<String, dynamic>),
      playlistLensItem: json['Playlist'] == null
          ? null
          : PlaylistLensItem.fromJson(json['Playlist'] as Map<String, dynamic>),
      storyLensItem: json['Story'] == null
          ? null
          : StoryLensItem.fromJson(json['Story'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecommendationsItemToJson(
        RecommendationsItem instance) =>
    <String, dynamic>{
      'ObjectID': instance.objectId,
      'ObjectType': instance.objectType,
      'Challenge': instance.challengeLensItem,
      'Playlist': instance.playlistLensItem,
      'Story': instance.storyLensItem,
    };
