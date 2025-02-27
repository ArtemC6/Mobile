import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:voccent/playlist/cubit/models/playlist_item.dart';

part 'playlist.g.dart';

@JsonSerializable()
class Playlist extends Equatable {
  const Playlist({
    this.id = '',
    this.createdAt,
    this.channelId,
    this.createdBy,
    this.items,
    this.name,
    this.pictureIdFirst,
  });

  const Playlist.loading() : this(id: '...');

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistToJson(this);

  @JsonKey(name: 'ID')
  final String id;

  @JsonKey(name: 'createdt')
  final String? createdAt;

  @JsonKey(name: 'createdby')
  final String? createdBy;

  @JsonKey(name: 'ChannelID')
  final String? channelId;

  @JsonKey(name: 'Name')
  final String? name;

  @JsonKey(name: 'Items')
  final List<PlaylistItem>? items;

  @JsonKey(name: 'PictureIDFirst')
  final String? pictureIdFirst;

  Playlist copyWithViewedChallenge(int index) {
    final i = List<PlaylistItem>.from(items!);

    i[index] = i[index].copyWith(challenge: i[index].challenge!.viewedCopy());

    return Playlist(
      channelId: channelId,
      createdAt: createdAt,
      createdBy: createdBy,
      id: id,
      items: i,
      name: name,
      pictureIdFirst: pictureIdFirst,
    );
  }

  @override
  List<Object?> get props => [id, items];
}
