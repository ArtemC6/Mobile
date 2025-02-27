import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset.g.dart';

@JsonSerializable()
class Asset extends Equatable {
  const Asset({
    this.challengePicture,
    this.channelAvatar,
    this.channelBanner,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
  @JsonKey(name: 'challenge_picture')
  final List<String>? challengePicture;

  @JsonKey(name: 'channel_avatar')
  final List<String>? channelAvatar;

  @JsonKey(name: 'channel_banner')
  final List<String>? channelBanner;

  Map<String, dynamic> toJson() => _$AssetToJson(this);

  @override
  List<Object?> get props => [
        challengePicture,
        channelAvatar,
        channelBanner,
      ];
}
