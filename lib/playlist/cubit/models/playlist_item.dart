import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:voccent/challenge/cubit/models/challenge.dart';

part 'playlist_item.g.dart';

@JsonSerializable()
class PlaylistItem extends Equatable {
  const PlaylistItem({
    this.challenge,
  });

  factory PlaylistItem.fromJson(Map<String, dynamic> json) =>
      _$PlaylistItemFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistItemToJson(this);

  @JsonKey(name: 'Challenge')
  final Challenge? challenge;

  PlaylistItem copyWith({
    Challenge? challenge,
  }) {
    return PlaylistItem(
      challenge: challenge ?? this.challenge,
    );
  }

  @override
  List<Object?> get props => [challenge];
}
