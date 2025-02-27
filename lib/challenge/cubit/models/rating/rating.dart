import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rating.g.dart';

@JsonSerializable()
class Rating extends Equatable {
  const Rating({
    required this.id,
    this.createdAt,
    this.createdBy,
    this.objectId,
    this.score = 0,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return _$RatingFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RatingToJson(this);

  @JsonKey(name: 'ID')
  final String id;
  @JsonKey(name: 'createdat')
  final DateTime? createdAt;
  @JsonKey(name: 'createdby')
  final String? createdBy;
  @JsonKey(name: 'ObjectID')
  final String? objectId;
  @JsonKey(name: 'Score')
  final double score;

  Rating copyWith({
    String? id,
    DateTime? createdAt,
    String? createdBy,
    String? objectId,
    double? score,
  }) {
    return Rating(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      objectId: objectId ?? this.objectId,
      score: score ?? this.score,
    );
  }

  @override
  List<Object?> get props => [id];
}
