import 'package:json_annotation/json_annotation.dart';

part 'challenge_accept_data.g.dart';

@JsonSerializable()
class ChallengeAcceptData {
  ChallengeAcceptData({
    this.id,
    this.createdat,
    this.updatedat,
    this.createdby,
    this.challengeId,
    this.attemptId,
    this.shareAll,
    this.shareAuthor,
    this.countAttempts,
    this.rating,
    this.difficultyMatch,
    this.attemptCreatedAt,
    this.totalPercent,
    this.pronunciationPercent,
    this.energyPercent,
    this.breathPercent,
    this.emotionPercent,
    this.pitchPercent,
    this.audioSampleTstId,
    this.pronunciationCompResultId,
    this.pitchCompResultId,
    this.energyCompResultId,
    this.breathCompResultId,
    this.emotionCompResultId,
  });

  factory ChallengeAcceptData.fromJson(Map<String, dynamic> json) =>
      _$ChallengeAcceptDataFromJson(json);
  @JsonKey(name: 'ID')
  String? id;
  DateTime? createdat;
  DateTime? updatedat;
  String? createdby;
  @JsonKey(name: 'ChallengeID')
  String? challengeId;
  @JsonKey(name: 'AttemptID')
  String? attemptId;
  @JsonKey(name: 'ShareAll')
  List<String>? shareAll;
  @JsonKey(name: 'ShareAuthor')
  List<String>? shareAuthor;
  @JsonKey(name: 'CountAttempts')
  int? countAttempts;
  @JsonKey(name: 'Rating')
  dynamic rating;
  @JsonKey(name: 'DifficultyMatch')
  double? difficultyMatch;
  @JsonKey(name: 'AttemptCreatedAt')
  DateTime? attemptCreatedAt;
  @JsonKey(name: 'TotalPercent')
  double? totalPercent;
  @JsonKey(name: 'PronunciationPercent')
  double? pronunciationPercent;
  @JsonKey(name: 'EnergyPercent')
  int? energyPercent;
  @JsonKey(name: 'BreathPercent')
  int? breathPercent;
  @JsonKey(name: 'EmotionPercent')
  double? emotionPercent;
  @JsonKey(name: 'PitchPercent')
  int? pitchPercent;
  @JsonKey(name: 'AudioSampleTstID')
  String? audioSampleTstId;
  @JsonKey(name: 'PronunciationCompResultID')
  String? pronunciationCompResultId;
  @JsonKey(name: 'PitchCompResultID')
  String? pitchCompResultId;
  @JsonKey(name: 'EnergyCompResultID')
  String? energyCompResultId;
  @JsonKey(name: 'BreathCompResultID')
  String? breathCompResultId;
  @JsonKey(name: 'EmotionCompResultID')
  String? emotionCompResultId;

  Map<String, dynamic> toJson() => _$ChallengeAcceptDataToJson(this);

  ChallengeAcceptData copyWith({
    String? id,
    DateTime? createdat,
    DateTime? updatedat,
    String? createdby,
    String? challengeId,
    String? attemptId,
    List<String>? shareAll,
    List<String>? shareAuthor,
    int? countAttempts,
    dynamic rating,
    double? difficultyMatch,
    DateTime? attemptCreatedAt,
    double? totalPercent,
    double? pronunciationPercent,
    int? energyPercent,
    int? breathPercent,
    double? emotionPercent,
    int? pitchPercent,
    String? audioSampleTstId,
    String? pronunciationCompResultId,
    String? pitchCompResultId,
    String? energyCompResultId,
    String? breathCompResultId,
    String? emotionCompResultId,
  }) {
    return ChallengeAcceptData(
      id: id ?? this.id,
      createdat: createdat ?? this.createdat,
      updatedat: updatedat ?? this.updatedat,
      createdby: createdby ?? this.createdby,
      challengeId: challengeId ?? this.challengeId,
      attemptId: attemptId ?? this.attemptId,
      shareAll: shareAll ?? this.shareAll,
      shareAuthor: shareAuthor ?? this.shareAuthor,
      countAttempts: countAttempts ?? this.countAttempts,
      rating: rating ?? this.rating,
      difficultyMatch: difficultyMatch ?? this.difficultyMatch,
      attemptCreatedAt: attemptCreatedAt ?? this.attemptCreatedAt,
      totalPercent: totalPercent ?? this.totalPercent,
      pronunciationPercent: pronunciationPercent ?? this.pronunciationPercent,
      energyPercent: energyPercent ?? this.energyPercent,
      breathPercent: breathPercent ?? this.breathPercent,
      emotionPercent: emotionPercent ?? this.emotionPercent,
      pitchPercent: pitchPercent ?? this.pitchPercent,
      audioSampleTstId: audioSampleTstId ?? this.audioSampleTstId,
      pronunciationCompResultId:
          pronunciationCompResultId ?? this.pronunciationCompResultId,
      pitchCompResultId: pitchCompResultId ?? this.pitchCompResultId,
      energyCompResultId: energyCompResultId ?? this.energyCompResultId,
      breathCompResultId: breathCompResultId ?? this.breathCompResultId,
      emotionCompResultId: emotionCompResultId ?? this.emotionCompResultId,
    );
  }
}
