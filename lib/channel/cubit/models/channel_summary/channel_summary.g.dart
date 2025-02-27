// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'channel_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelSummary _$ChannelSummaryFromJson(Map<String, dynamic> json) =>
    ChannelSummary(
      playlists: (json['Playlists'] as num?)?.toInt(),
      challenges: (json['Challenges'] as num?)?.toInt(),
      stories: (json['Stories'] as num?)?.toInt(),
      countRating: (json['CountRating'] as num?)?.toInt(),
      rating: (json['Rating'] as num?)?.toDouble(),
      playlistsThisMonth: (json['PlaylistsThisMonth'] as num?)?.toInt(),
      challengesThisMonth: (json['ChallengesThisMonth'] as num?)?.toInt(),
      storiesThisMonth: (json['StoriesThisMonth'] as num?)?.toInt(),
      lastUpdated: json['LastUpdated'] == null
          ? null
          : DateTime.parse(json['LastUpdated'] as String),
    );

Map<String, dynamic> _$ChannelSummaryToJson(ChannelSummary instance) =>
    <String, dynamic>{
      'Playlists': instance.playlists,
      'Challenges': instance.challenges,
      'Stories': instance.stories,
      'CountRating': instance.countRating,
      'Rating': instance.rating,
      'PlaylistsThisMonth': instance.playlistsThisMonth,
      'ChallengesThisMonth': instance.challengesThisMonth,
      'StoriesThisMonth': instance.storiesThisMonth,
      'LastUpdated': instance.lastUpdated?.toIso8601String(),
    };
