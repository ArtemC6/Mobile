import 'package:json_annotation/json_annotation.dart';

part 'asset.g.dart';

@JsonSerializable()
class Asset {
  Asset({this.challengePicture});

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
  @JsonKey(name: 'challenge_picture')
  List<String>? challengePicture;

  Map<String, dynamic> toJson() => _$AssetToJson(this);

  Asset copyWith({
    List<String>? challengePicture,
  }) {
    return Asset(
      challengePicture: challengePicture ?? this.challengePicture,
    );
  }
}
