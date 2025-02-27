import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:voccent/lens/cubit/models/lens_v2/challenge_lens_item.dart';
import 'package:voccent/lens/cubit/models/lens_v2/playlist_lens_item.dart';
import 'package:voccent/lens/cubit/models/lens_v2/story_lens_item.dart';

part 'recommendations_item.g.dart';

@JsonSerializable()
class RecommendationsItem extends Equatable {
  const RecommendationsItem({
    this.objectId,
    this.objectType,
    this.challengeLensItem,
    this.playlistLensItem,
    this.storyLensItem,
  });
  factory RecommendationsItem.fromJson(Map<String, dynamic> json) =>
      _$RecommendationsItemFromJson(json);
  @JsonKey(name: 'ObjectID')
  final String? objectId;
  @JsonKey(name: 'ObjectType')
  final String? objectType;
  @JsonKey(name: 'Challenge')
  final ChallengeLensItem? challengeLensItem;
  @JsonKey(name: 'Playlist')
  final PlaylistLensItem? playlistLensItem;
  @JsonKey(name: 'Story')
  final StoryLensItem? storyLensItem;

  Map<String, dynamic> toJson() => _$RecommendationsItemToJson(this);

  RecommendationsItem copyWith({
    String? objectId,
    String? objectType,
    ChallengeLensItem? challengeLensItem,
    PlaylistLensItem? playlistLensItem,
    StoryLensItem? storyLensItem,
  }) {
    return RecommendationsItem(
      objectId: objectId ?? this.objectId,
      objectType: objectType ?? this.objectType,
      challengeLensItem: challengeLensItem ?? this.challengeLensItem,
      playlistLensItem: playlistLensItem ?? this.playlistLensItem,
      storyLensItem: storyLensItem ?? this.storyLensItem,
    );
  }

  @override
  List<Object?> get props => throw UnimplementedError();
}
