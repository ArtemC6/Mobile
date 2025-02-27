import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'challenge.g.dart';

@JsonSerializable()
class Challenge extends Equatable {
  const Challenge({
    this.createdAt,
    this.id = '',
    this.name = '',
    this.audioSampleRefID = '',
    this.userName = '',
    this.channelName = '',
    this.channelId = '',
    this.rating = 0,
    this.level = 50,
    this.mode = '',
    this.asset,
    this.languageId,
    this.spelling,
    this.isViewed = false,
  });

  Challenge.loading()
      : this(
          name: '...',
          userName: '...',
          channelName: '...',
          createdAt: DateTime.now(),
        );

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);
  Map<String, dynamic> toJson() => _$ChallengeToJson(this);

  Challenge viewedCopy() {
    return Challenge(
      isViewed: true,
      id: id,
      name: name,
      audioSampleRefID: audioSampleRefID,
      userName: userName,
      channelName: channelName,
      channelId: channelId,
      rating: rating,
      level: level,
      mode: mode,
      asset: asset,
      createdAt: createdAt,
      languageId: languageId,
      spelling: spelling,
    );
  }

  @JsonKey(name: 'ID')
  final String id;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'AudioSampleRefID')
  final String audioSampleRefID;

  @JsonKey(name: 'UserName')
  final String userName;

  @JsonKey(name: 'ChannelName')
  final String channelName;

  @JsonKey(name: 'ChannelID')
  final String channelId;

  @JsonKey(name: 'Mode') // 'monolog' or 'interactive'
  final String mode;

  @JsonKey(name: 'Level')
  final int level;

  @JsonKey(name: 'Rating')
  final double rating;

  @JsonKey(name: 'createdat')
  final DateTime? createdAt;

  @JsonKey(name: 'Asset')
  final Map<String, dynamic>? asset;

  @JsonKey(name: 'LanguageID')
  final String? languageId;

  @JsonKey(name: 'Spelling')
  final String? spelling;

  final bool isViewed;

  @override
  List<Object> get props => [id, isViewed];
}
