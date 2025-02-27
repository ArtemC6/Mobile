import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'condition.g.dart';

@JsonSerializable()
class Condition extends Equatable {
  const Condition({
    this.actDescription,
    this.actId,
    this.actName,
    this.createdAt,
    this.vote,
  });

  factory Condition.fromJson(Map<String, dynamic> json) =>
      _$ConditionFromJson(json);
  Map<String, dynamic> toJson() => _$ConditionToJson(this);

  @JsonKey(name: 'ActDescription')
  final String? actDescription;
  @JsonKey(name: 'ActID')
  final String? actId;
  @JsonKey(name: 'ActName')
  final String? actName;
  @JsonKey(name: 'CreatedAt')
  final String? createdAt;
  @JsonKey(name: 'Vote')
  final String? vote;

  Condition copyWith({
    String? actDescription,
    String? actId,
    String? actName,
    String? createdAt,
    String? vote,
  }) {
    return Condition(
      actDescription: actDescription ?? this.actDescription,
      actId: actId ?? this.actId,
      actName: actName ?? this.actName,
      createdAt: createdAt ?? this.createdAt,
      vote: vote ?? this.vote,
    );
  }

  @override
  List<Object?> get props => [
        actDescription,
        actId,
        actName,
        createdAt,
        vote,
      ];
}
