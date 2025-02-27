// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'skip_pause_vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkipPauseVote _$SkipPauseVoteFromJson(Map<String, dynamic> json) =>
    SkipPauseVote(
      itemId: json['ItemID'] as String?,
      vote: (json['Vote'] as num?)?.toInt(),
      voteAll: (json['VoteAll'] as num?)?.toInt(),
      weVoted: json['weVoted'] as bool? ?? false,
    );

Map<String, dynamic> _$SkipPauseVoteToJson(SkipPauseVote instance) =>
    <String, dynamic>{
      'ItemID': instance.itemId,
      'Vote': instance.vote,
      'VoteAll': instance.voteAll,
      'weVoted': instance.weVoted,
    };
