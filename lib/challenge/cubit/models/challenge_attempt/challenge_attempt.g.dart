// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'challenge_attempt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeAttempt _$ChallengeAttemptFromJson(Map<String, dynamic> json) =>
    ChallengeAttempt(
      id: json['ID'] as String?,
      createdat: json['createdat'] == null
          ? null
          : DateTime.parse(json['createdat'] as String),
      updatedat: json['updatedat'] == null
          ? null
          : DateTime.parse(json['updatedat'] as String),
      createdby: json['createdby'] as String?,
      challengeId: json['ChallengeID'] as String?,
      pronunciationCompResultId: json['PronunciationCompResultID'] as String?,
      audioSampleTstId: json['AudioSampleTstID'] as String?,
      audioSampleRefId: json['AudioSampleRefID'] as String?,
      pitchCompResultId: json['PitchCompResultID'] as String?,
      energyCompResultId: json['EnergyCompResultID'] as String?,
      breathCompResultId: json['BreathCompResultID'] as String?,
      emotionCompResultId: json['EmotionCompResultID'] as String?,
      pronunciationPercent: (json['PronunciationPercent'] as num?)?.toDouble(),
      pitchPercent: (json['PitchPercent'] as num?)?.toDouble() ?? 0,
      energyPercent: (json['EnergyPercent'] as num?)?.toDouble() ?? 0,
      breathPercent: (json['BreathPercent'] as num?)?.toDouble() ?? 0,
      emotionPercent: (json['EmotionPercent'] as num?)?.toDouble() ?? 0,
      totalPercent: (json['TotalPercent'] as num?)?.toDouble() ?? 0,
      xpAdd: (json['XPAdd'] as num?)?.toInt(),
      xpFactorAdd: (json['XPFactorAdd'] as num?)?.toInt(),
      xpTotal: (json['XPTotal'] as num?)?.toInt(),
      xpFactorCurrent: (json['XPFactorCurrent'] as num?)?.toInt(),
      pronunciationData: json['PronunciationData'] == null
          ? null
          : PronunciationData.fromJson(
              json['PronunciationData'] as Map<String, dynamic>),
      pitchData: json['PitchData'] == null
          ? null
          : FramesData.fromJson(json['PitchData'] as Map<String, dynamic>),
      energyData: json['EnergyData'] == null
          ? null
          : FramesData.fromJson(json['EnergyData'] as Map<String, dynamic>),
      breathData: json['BreathData'] == null
          ? null
          : FramesData.fromJson(json['BreathData'] as Map<String, dynamic>),
      emotionData: json['EmotionData'] == null
          ? null
          : EmotionData.fromJson(json['EmotionData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChallengeAttemptToJson(ChallengeAttempt instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'createdat': instance.createdat?.toIso8601String(),
      'updatedat': instance.updatedat?.toIso8601String(),
      'createdby': instance.createdby,
      'ChallengeID': instance.challengeId,
      'PronunciationCompResultID': instance.pronunciationCompResultId,
      'AudioSampleTstID': instance.audioSampleTstId,
      'AudioSampleRefID': instance.audioSampleRefId,
      'PitchCompResultID': instance.pitchCompResultId,
      'EnergyCompResultID': instance.energyCompResultId,
      'BreathCompResultID': instance.breathCompResultId,
      'EmotionCompResultID': instance.emotionCompResultId,
      'PronunciationPercent': instance.pronunciationPercent,
      'PitchPercent': instance.pitchPercent,
      'EnergyPercent': instance.energyPercent,
      'BreathPercent': instance.breathPercent,
      'EmotionPercent': instance.emotionPercent,
      'TotalPercent': instance.totalPercent,
      'XPAdd': instance.xpAdd,
      'XPFactorAdd': instance.xpFactorAdd,
      'XPTotal': instance.xpTotal,
      'XPFactorCurrent': instance.xpFactorCurrent,
      'PronunciationData': instance.pronunciationData,
      'PitchData': instance.pitchData,
      'EnergyData': instance.energyData,
      'BreathData': instance.breathData,
      'EmotionData': instance.emotionData,
    };
