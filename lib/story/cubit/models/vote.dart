import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vote.g.dart';

@JsonSerializable()
class Vote extends Equatable {
  const Vote({
    this.actId,
    this.actIdMinus,
    this.actIdPlus,
    this.voteMinus,
    this.votePlus,
  });

  factory Vote.fromJson(Map<String, dynamic> json) => _$VoteFromJson(json);
  Map<String, dynamic> toJson() => _$VoteToJson(this);

  @JsonKey(name: 'ActID')
  final String? actId;
  @JsonKey(name: 'ActIDMinus')
  final String? actIdMinus;
  @JsonKey(name: 'ActIDPlus')
  final String? actIdPlus;
  @JsonKey(name: 'VoteMinus')
  final int? voteMinus;
  @JsonKey(name: 'VotePlus')
  final int? votePlus;

  @override
  List<Object?> get props => [];
}
