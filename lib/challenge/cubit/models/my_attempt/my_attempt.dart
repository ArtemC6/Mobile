import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_attempt.g.dart';

@JsonSerializable()
class MyAttempt {
  const MyAttempt({
    required this.id,
    required this.createdAt,
    required this.createdBy,
    required this.challengeId,
    required this.pronunciationCompResultId,
    required this.audioSampleRefId,
    required this.audioSampleTestId,
    required this.emotionCompResultId,
    required this.pitchCompResultId,
    required this.breathCompResultId,
    required this.energyCompResultId,
    required this.pronunciationPercent,
    required this.pitchPercent,
    required this.energyPercent,
    required this.emotionPercent,
    required this.breathPercent,
    required this.totalPercent,
    required this.difficulty,
    required this.xpAdd,
    required this.xpFactorAdd,
    required this.xpTotal,
    required this.xpFactorCurrent,
  });

  factory MyAttempt.fromJson(Map<String, dynamic> json) {
    return _$MyAttemptFromJson(json);
  }

  String? get createdAtLocal => Intl().date().format(createdAt.toLocal());

  @JsonKey(name: 'ID')
  final String id;
  @JsonKey(name: 'createdat')
  final DateTime createdAt;
  @JsonKey(name: 'createdby')
  final String createdBy;
  @JsonKey(name: 'ChallengeID')
  final String challengeId;
  @JsonKey(name: 'PronunciationCompResultID')
  final String pronunciationCompResultId;
  @JsonKey(name: 'AudioSampleRefID')
  final String audioSampleRefId;
  @JsonKey(name: 'AudioSampleTstID')
  final String audioSampleTestId;
  @JsonKey(name: 'EmotionCompResultID')
  final String emotionCompResultId;
  @JsonKey(name: 'PitchCompResultID')
  final String pitchCompResultId;
  @JsonKey(name: 'EnergyCompResultID')
  final String energyCompResultId;
  @JsonKey(name: 'BreathCompResultID')
  final String breathCompResultId;
  @JsonKey(name: 'PronunciationPercent')
  final double pronunciationPercent;
  @JsonKey(name: 'PitchPercent')
  final double pitchPercent;
  @JsonKey(name: 'EmotionPercent')
  final double emotionPercent;
  @JsonKey(name: 'BreathPercent')
  final double breathPercent;
  @JsonKey(name: 'EnergyPercent')
  final double energyPercent;
  @JsonKey(name: 'TotalPercent')
  final double totalPercent;
  @JsonKey(name: 'Difficulty')
  final int? difficulty;
  @JsonKey(name: 'XPAdd')
  final int? xpAdd;
  @JsonKey(name: 'XPFactorAdd')
  final int? xpFactorAdd;
  @JsonKey(name: 'XPTotal')
  final int? xpTotal;
  @JsonKey(name: 'XPFactorCurrent')
  final int? xpFactorCurrent;

  Map<String, dynamic> toJson() => _$MyAttemptToJson(this);
}
