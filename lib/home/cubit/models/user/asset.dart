import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset.g.dart';

@JsonSerializable()
class Asset extends Equatable {
  const Asset({this.userAvatar});

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);

  @JsonKey(name: 'user_avatar')
  final List<String>? userAvatar;

  Map<String, dynamic> toJson() => _$AssetToJson(this);

  @override
  List<Object?> get props => [userAvatar];
}
