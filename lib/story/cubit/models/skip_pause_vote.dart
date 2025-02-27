import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'skip_pause_vote.g.dart';

@JsonSerializable()
class SkipPauseVote extends Equatable {
  const SkipPauseVote({
    this.itemId,
    this.vote,
    this.voteAll,
    this.weVoted = false,
  });

  factory SkipPauseVote.fromJson(Map<String, dynamic> json) =>
      _$SkipPauseVoteFromJson(json);
  Map<String, dynamic> toJson() => _$SkipPauseVoteToJson(this);

  @JsonKey(name: 'ItemID')
  final String? itemId;
  @JsonKey(name: 'Vote')
  final int? vote;
  @JsonKey(name: 'VoteAll')
  final int? voteAll;
  final bool weVoted;

  SkipPauseVote copyWith({
    String? itemId,
    int? vote,
    int? voteAll,
    bool? weVoted,
  }) {
    return SkipPauseVote(
      itemId: itemId ?? this.itemId,
      vote: vote ?? this.vote,
      voteAll: voteAll ?? this.voteAll,
      weVoted: weVoted ?? this.weVoted,
    );
  }

  @override
  List<Object?> get props => [
        itemId,
        vote,
        voteAll,
        weVoted,
      ];
}
