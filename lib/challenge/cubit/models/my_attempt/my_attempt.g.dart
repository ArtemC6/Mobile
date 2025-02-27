// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'my_attempt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyAttempt _$MyAttemptFromJson(Map<String, dynamic> json) => MyAttempt(
      id: json['ID'] as String,
      createdAt: DateTime.parse(json['createdat'] as String),
      createdBy: json['createdby'] as String,
      challengeId: json['ChallengeID'] as String,
      pronunciationCompResultId: json['PronunciationCompResultID'] as String,
      audioSampleRefId: json['AudioSampleRefID'] as String,
      audioSampleTestId: json['AudioSampleTstID'] as String,
      emotionCompResultId: json['EmotionCompResultID'] as String,
      pitchCompResultId: json['PitchCompResultID'] as String,
      breathCompResultId: json['BreathCompResultID'] as String,
      energyCompResultId: json['EnergyCompResultID'] as String,
      pronunciationPercent: (json['PronunciationPercent'] as num).toDouble(),
      pitchPercent: (json['PitchPercent'] as num).toDouble(),
      energyPercent: (json['EnergyPercent'] as num).toDouble(),
      emotionPercent: (json['EmotionPercent'] as num).toDouble(),
      breathPercent: (json['BreathPercent'] as num).toDouble(),
      totalPercent: (json['TotalPercent'] as num).toDouble(),
      difficulty: (json['Difficulty'] as num?)?.toInt(),
      xpAdd: (json['XPAdd'] as num?)?.toInt(),
      xpFactorAdd: (json['XPFactorAdd'] as num?)?.toInt(),
      xpTotal: (json['XPTotal'] as num?)?.toInt(),
      xpFactorCurrent: (json['XPFactorCurrent'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MyAttemptToJson(MyAttempt instance) => <String, dynamic>{
      'ID': instance.id,
      'createdat': instance.createdAt.toIso8601String(),
      'createdby': instance.createdBy,
      'ChallengeID': instance.challengeId,
      'PronunciationCompResultID': instance.pronunciationCompResultId,
      'AudioSampleRefID': instance.audioSampleRefId,
      'AudioSampleTstID': instance.audioSampleTestId,
      'EmotionCompResultID': instance.emotionCompResultId,
      'PitchCompResultID': instance.pitchCompResultId,
      'EnergyCompResultID': instance.energyCompResultId,
      'BreathCompResultID': instance.breathCompResultId,
      'PronunciationPercent': instance.pronunciationPercent,
      'PitchPercent': instance.pitchPercent,
      'EmotionPercent': instance.emotionPercent,
      'BreathPercent': instance.breathPercent,
      'EnergyPercent': instance.energyPercent,
      'TotalPercent': instance.totalPercent,
      'Difficulty': instance.difficulty,
      'XPAdd': instance.xpAdd,
      'XPFactorAdd': instance.xpFactorAdd,
      'XPTotal': instance.xpTotal,
      'XPFactorCurrent': instance.xpFactorCurrent,
    };
