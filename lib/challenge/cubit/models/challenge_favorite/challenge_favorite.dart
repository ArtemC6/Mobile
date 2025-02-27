import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'challenge_favorite.g.dart';

@JsonSerializable()
class ChallengeFavorite extends Equatable {
  const ChallengeFavorite({
    required this.userId,
    required this.objectId,
    required this.isFavorite,
  });

  factory ChallengeFavorite.fromJson(Map<String, dynamic> json) {
    return _$ChallengeFavoriteFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ChallengeFavoriteToJson(this);

  @JsonKey(name: 'UserID')
  final String userId;
  @JsonKey(name: 'ObjectID')
  final String objectId;
  @JsonKey(name: 'IsFavorite')
  final bool isFavorite;

  ChallengeFavorite copyWith({
    String? userId,
    String? objectId,
    bool? isFavorite,
  }) {
    return ChallengeFavorite(
      userId: userId ?? this.userId,
      objectId: objectId ?? this.objectId,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        objectId,
        isFavorite,
      ];
}
