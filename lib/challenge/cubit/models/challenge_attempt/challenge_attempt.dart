import 'package:json_annotation/json_annotation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:voccent/challenge/cubit/models/challenge_attempt/emotion_data.dart';
import 'package:voccent/challenge/cubit/models/challenge_attempt/frames_data.dart';
import 'package:voccent/challenge/cubit/models/challenge_attempt/pronunciation_data.dart';
import 'package:voccent/challenge/cubit/models/my_attempt/my_attempt.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/fingerprint.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/frame.dart';

part 'challenge_attempt.g.dart';

@JsonSerializable()
class ChallengeAttempt {
  ChallengeAttempt({
    this.id,
    this.createdat,
    this.updatedat,
    this.createdby,
    this.challengeId,
    this.pronunciationCompResultId,
    this.audioSampleTstId,
    this.audioSampleRefId,
    this.pitchCompResultId,
    this.energyCompResultId,
    this.breathCompResultId,
    this.emotionCompResultId,
    this.pronunciationPercent,
    this.pitchPercent = 0,
    this.energyPercent = 0,
    this.breathPercent = 0,
    this.emotionPercent = 0,
    this.totalPercent = 0,
    this.xpAdd,
    this.xpFactorAdd,
    this.xpTotal,
    this.xpFactorCurrent,
    this.pronunciationData,
    this.pitchData,
    this.energyData,
    this.breathData,
    this.emotionData,
  }) {
    pronunciationSeries = <LineSeries<Frame, double>>[
      LineSeries<Frame, double>(
        name: 'Pronunciation similarity',
        xValueMapper: (Frame frame, _) => frame.segmentStart,
        yValueMapper: (Frame frame, _) => frame.combinedPronunciation,
        dataSource: pronunciationData?.frames ?? [],
      ),
    ];

    energySeries = <LineSeries<Frame, double>>[
      LineSeries<Frame, double>(
        name: 'Energy',
        xValueMapper: (Frame frame, _) => frame.segmentStart,
        yValueMapper: (Frame frame, _) => frame.positiveEnergy,
        dataSource: energyData?.frames ?? [],
      ),
    ];

    pitchSeries = <LineSeries<Frame, double>>[
      LineSeries<Frame, double>(
        name: 'Pitch',
        xValueMapper: (Frame frame, _) => frame.segmentStart,
        yValueMapper: (Frame frame, _) => frame.positivePitch,
        dataSource: pitchData?.frames ?? [],
      ),
    ];
  }
  factory ChallengeAttempt.fromFingerprint(
    MyAttempt myAttempt,
    Fingerprint fingers,
    EmotionData emotionData,
  ) {
    return ChallengeAttempt(
      audioSampleRefId: myAttempt.audioSampleRefId,
      audioSampleTstId: myAttempt.audioSampleTestId,
      breathCompResultId: myAttempt.breathCompResultId,
      breathData: FramesData(
        frames:
            fingers.fingerprintDataJoinedSegments34530eeb.breath22cbbd85.frames,
      ),
      breathPercent:
          fingers.fingerprintDataJoinedSegments34530eeb.breath22cbbd85.breath,
      challengeId: myAttempt.challengeId,
      createdat: myAttempt.createdAt,
      createdby: myAttempt.createdBy,
      emotionCompResultId: myAttempt.emotionCompResultId,
      emotionData: emotionData,
      emotionPercent: myAttempt.emotionPercent,
      energyCompResultId: myAttempt.energyCompResultId,
      energyData: FramesData(
        frames: fingers
            .fingerprintDataJoinedSegments34530eeb.prosodyC7f1eb37.frames,
      ),
      energyPercent: myAttempt.energyPercent,
      id: myAttempt.id,
      pitchCompResultId: myAttempt.pitchCompResultId,
      pitchData: FramesData(
        frames: fingers
            .fingerprintDataJoinedSegments34530eeb.prosodyC7f1eb37.frames,
      ),
      pitchPercent: myAttempt.pitchPercent,
      pronunciationCompResultId: myAttempt.pronunciationCompResultId,
      pronunciationData: PronunciationData(
        frames: fingers
            .fingerprintDataJoinedSegments34530eeb.pronunciationE1cbebc6.frames,
        dp: fingers
            .fingerprintDataJoinedSegments34530eeb.pronunciationE1cbebc6.dp,
      ),
      pronunciationPercent: myAttempt.pronunciationPercent,
      totalPercent: myAttempt.totalPercent,
      xpAdd: myAttempt.xpAdd,
      xpFactorAdd: myAttempt.xpFactorAdd,
      xpFactorCurrent: myAttempt.xpFactorCurrent,
      xpTotal: myAttempt.xpTotal,
    );
  }

  factory ChallengeAttempt.fromJson(Map<String, dynamic> json) {
    return _$ChallengeAttemptFromJson(json);
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
  String? audioSampleRefId;
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
  @JsonKey(name: 'PitchPercent', defaultValue: 0)
  double pitchPercent;
  @JsonKey(name: 'EnergyPercent', defaultValue: 0)
  double energyPercent;
  @JsonKey(name: 'BreathPercent', defaultValue: 0)
  double breathPercent;
  @JsonKey(name: 'EmotionPercent', defaultValue: 0)
  double emotionPercent;
  @JsonKey(name: 'TotalPercent', defaultValue: 0)
  double totalPercent;
  @JsonKey(name: 'XPAdd')
  final int? xpAdd;
  @JsonKey(name: 'XPFactorAdd')
  final int? xpFactorAdd;
  @JsonKey(name: 'XPTotal')
  final int? xpTotal;
  @JsonKey(name: 'XPFactorCurrent')
  final int? xpFactorCurrent;
  @JsonKey(name: 'PronunciationData')
  PronunciationData? pronunciationData;
  @JsonKey(name: 'PitchData')
  FramesData? pitchData;
  @JsonKey(name: 'EnergyData')
  FramesData? energyData;
  @JsonKey(name: 'BreathData')
  FramesData? breathData;
  @JsonKey(name: 'EmotionData')
  EmotionData? emotionData;

  Map<String, dynamic> toJson() => _$ChallengeAttemptToJson(this);

  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  late final List<LineSeries<Frame, double>> pronunciationSeries;
  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  late final List<LineSeries<Frame, double>> energySeries;
  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  late final List<LineSeries<Frame, double>> pitchSeries;
}
