import 'package:json_annotation/json_annotation.dart';

part 'shared_attempts.g.dart';

@JsonSerializable()
class SharedAttempt {
  SharedAttempt({
    this.id,
    this.createdat,
    this.updatedat,
    this.createdby,
    this.challengeId,
    this.pronunciationCompResultId,
    this.audioSampleTstId,
    this.audioSampleRefId,
    this.ipaCompResultId,
    this.pitchCompResultId,
    this.energyCompResultId,
    this.breathCompResultId,
    this.emotionCompResultId,
    this.pronunciationPercent,
    this.pitchPercent,
    this.energyPercent,
    this.breathPercent,
    this.emotionPercent,
    this.totalPercent,
    this.difficulty,
    this.level,
    this.xpAdd,
    this.xpFactorAdd,
    this.xpTotal,
    this.xpFactorCurrent,
    this.shareAll,
    this.shareAuthor,
    this.isShareVoice,
    this.userName,
  });

  factory SharedAttempt.fromJson(Map<String, dynamic> json) {
    return _$SharedAttemptFromJson(json);
  }
  @JsonKey(name: 'ID')
  String? id;
  DateTime? createdat;
  DateTime? updatedat;
  String? createdby;
  @JsonKey(name: 'ChallengeID')
  String? challengeId;
  @JsonKey(name: 'PronunciationCompResultID')
  String? pronunciationCompResultId;
  @JsonKey(name: 'AudioSampleTstID')
  String? audioSampleTstId;
  @JsonKey(name: 'AudioSampleRefID')
  dynamic audioSampleRefId;
  @JsonKey(name: 'IpaCompResultID')
  String? ipaCompResultId;
  @JsonKey(name: 'PitchCompResultID')
  String? pitchCompResultId;
  @JsonKey(name: 'EnergyCompResultID')
  String? energyCompResultId;
  @JsonKey(name: 'BreathCompResultID')
  String? breathCompResultId;
  @JsonKey(name: 'EmotionCompResultID')
  String? emotionCompResultId;
  @JsonKey(name: 'PronunciationPercent')
  double? pronunciationPercent;
  @JsonKey(name: 'PitchPercent')
  double? pitchPercent;
  @JsonKey(name: 'EnergyPercent')
  double? energyPercent;
  @JsonKey(name: 'BreathPercent')
  double? breathPercent;
  @JsonKey(name: 'EmotionPercent')
  double? emotionPercent;
  @JsonKey(name: 'TotalPercent')
  double? totalPercent;
  @JsonKey(name: 'Difficulty')
  double? difficulty;
  @JsonKey(name: 'Level')
  dynamic level;
  @JsonKey(name: 'XPAdd')
  dynamic xpAdd;
  @JsonKey(name: 'XPFactorAdd')
  dynamic xpFactorAdd;
  @JsonKey(name: 'XPTotal')
  dynamic xpTotal;
  @JsonKey(name: 'XPFactorCurrent')
  dynamic xpFactorCurrent;
  @JsonKey(name: 'ShareAll')
  List<String>? shareAll;
  @JsonKey(name: 'ShareAuthor')
  dynamic shareAuthor;
  @JsonKey(name: 'IsShareVoice')
  bool? isShareVoice;
  @JsonKey(name: 'UserName')
  String? userName;

  Map<String, dynamic> toJson() => _$SharedAttemptToJson(this);

  SharedAttempt copyWith({
    String? id,
    DateTime? createdat,
    DateTime? updatedat,
    String? createdby,
    String? challengeId,
    String? pronunciationCompResultId,
    String? audioSampleTstId,
    dynamic audioSampleRefId,
    String? ipaCompResultId,
    String? pitchCompResultId,
    String? energyCompResultId,
    String? breathCompResultId,
    String? emotionCompResultId,
    double? pronunciationPercent,
    double? pitchPercent,
    double? energyPercent,
    double? breathPercent,
    double? emotionPercent,
    double? totalPercent,
    double? difficulty,
    dynamic level,
    dynamic xpAdd,
    dynamic xpFactorAdd,
    dynamic xpTotal,
    dynamic xpFactorCurrent,
    List<String>? shareAll,
    dynamic shareAuthor,
    bool? isShareVoice,
    String? userName,
  }) {
    return SharedAttempt(
      id: id ?? this.id,
      createdat: createdat ?? this.createdat,
      updatedat: updatedat ?? this.updatedat,
      createdby: createdby ?? this.createdby,
      challengeId: challengeId ?? this.challengeId,
      pronunciationCompResultId:
          pronunciationCompResultId ?? this.pronunciationCompResultId,
      audioSampleTstId: audioSampleTstId ?? this.audioSampleTstId,
      audioSampleRefId: audioSampleRefId ?? this.audioSampleRefId,
      ipaCompResultId: ipaCompResultId ?? this.ipaCompResultId,
      pitchCompResultId: pitchCompResultId ?? this.pitchCompResultId,
      energyCompResultId: energyCompResultId ?? this.energyCompResultId,
      breathCompResultId: breathCompResultId ?? this.breathCompResultId,
      emotionCompResultId: emotionCompResultId ?? this.emotionCompResultId,
      pronunciationPercent: pronunciationPercent ?? this.pronunciationPercent,
      pitchPercent: pitchPercent ?? this.pitchPercent,
      energyPercent: energyPercent ?? this.energyPercent,
      breathPercent: breathPercent ?? this.breathPercent,
      emotionPercent: emotionPercent ?? this.emotionPercent,
      totalPercent: totalPercent ?? this.totalPercent,
      difficulty: difficulty ?? this.difficulty,
      level: level ?? this.level,
      xpAdd: xpAdd ?? this.xpAdd,
      xpFactorAdd: xpFactorAdd ?? this.xpFactorAdd,
      xpTotal: xpTotal ?? this.xpTotal,
      xpFactorCurrent: xpFactorCurrent ?? this.xpFactorCurrent,
      shareAll: shareAll ?? this.shareAll,
      shareAuthor: shareAuthor ?? this.shareAuthor,
      isShareVoice: isShareVoice ?? this.isShareVoice,
      userName: userName ?? this.userName,
    );
  }
}
