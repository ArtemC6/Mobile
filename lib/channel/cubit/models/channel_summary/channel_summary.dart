import 'package:json_annotation/json_annotation.dart';

part 'channel_summary.g.dart';

@JsonSerializable()
class ChannelSummary {
  const ChannelSummary({
    this.playlists,
    this.challenges,
    this.stories,
    this.countRating,
    this.rating,
    this.playlistsThisMonth,
    this.challengesThisMonth,
    this.storiesThisMonth,
    this.lastUpdated,
  });

  factory ChannelSummary.fromJson(Map<String, dynamic> json) {
    return _$ChannelSummaryFromJson(json);
  }
  @JsonKey(name: 'Playlists')
  final int? playlists;
  @JsonKey(name: 'Challenges')
  final int? challenges;
  @JsonKey(name: 'Stories')
  final int? stories;
  @JsonKey(name: 'CountRating')
  final int? countRating;
  @JsonKey(name: 'Rating')
  final double? rating;
  @JsonKey(name: 'PlaylistsThisMonth')
  final int? playlistsThisMonth;
  @JsonKey(name: 'ChallengesThisMonth')
  final int? challengesThisMonth;
  @JsonKey(name: 'StoriesThisMonth')
  final int? storiesThisMonth;
  @JsonKey(name: 'LastUpdated')
  final DateTime? lastUpdated;

  Map<String, dynamic> toJson() => _$ChannelSummaryToJson(this);

  ChannelSummary copyWith({
    int? playlists,
    int? challenges,
    int? stories,
    int? countRating,
    double? rating,
    int? playlistsThisMonth,
    int? challengesThisMonth,
    int? storiesThisMonth,
    DateTime? lastUpdated,
  }) {
    return ChannelSummary(
      playlists: playlists ?? this.playlists,
      challenges: challenges ?? this.challenges,
      stories: stories ?? this.stories,
      countRating: countRating ?? this.countRating,
      rating: rating ?? this.rating,
      playlistsThisMonth: playlistsThisMonth ?? this.playlistsThisMonth,
      challengesThisMonth: challengesThisMonth ?? this.challengesThisMonth,
      storiesThisMonth: storiesThisMonth ?? this.storiesThisMonth,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
