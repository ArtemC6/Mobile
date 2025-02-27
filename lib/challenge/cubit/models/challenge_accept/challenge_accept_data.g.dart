// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'challenge_accept_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeAcceptData _$ChallengeAcceptDataFromJson(Map<String, dynamic> json) =>
    ChallengeAcceptData(
      id: json['ID'] as String?,
      createdat: json['createdat'] == null
          ? null
          : DateTime.parse(json['createdat'] as String),
      updatedat: json['updatedat'] == null
          ? null
          : DateTime.parse(json['updatedat'] as String),
      createdby: json['createdby'] as String?,
      challengeId: json['ChallengeID'] as String?,
      attemptId: json['AttemptID'] as String?,
      shareAll: (json['ShareAll'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      shareAuthor: (json['ShareAuthor'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      countAttempts: (json['CountAttempts'] as num?)?.toInt(),
      rating: json['Rating'],
      difficultyMatch: (json['DifficultyMatch'] as num?)?.toDouble(),
      attemptCreatedAt: json['AttemptCreatedAt'] == null
          ? null
          : DateTime.parse(json['AttemptCreatedAt'] as String),
      totalPercent: (json['TotalPercent'] as num?)?.toDouble(),
      pronunciationPercent: (json['PronunciationPercent'] as num?)?.toDouble(),
      energyPercent: (json['EnergyPercent'] as num?)?.toInt(),
      breathPercent: (json['BreathPercent'] as num?)?.toInt(),
      emotionPercent: (json['EmotionPercent'] as num?)?.toDouble(),
      pitchPercent: (json['PitchPercent'] as num?)?.toInt(),
      audioSampleTstId: json['AudioSampleTstID'] as String?,
      pronunciationCompResultId: json['PronunciationCompResultID'] as String?,
      pitchCompResultId: json['PitchCompResultID'] as String?,
      energyCompResultId: json['EnergyCompResultID'] as String?,
      breathCompResultId: json['BreathCompResultID'] as String?,
      emotionCompResultId: json['EmotionCompResultID'] as String?,
    );

Map<String, dynamic> _$ChallengeAcceptDataToJson(
        ChallengeAcceptData instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'createdat': instance.createdat?.toIso8601String(),
      'updatedat': instance.updatedat?.toIso8601String(),
      'createdby': instance.createdby,
      'ChallengeID': instance.challengeId,
      'AttemptID': instance.attemptId,
      'ShareAll': instance.shareAll,
      'ShareAuthor': instance.shareAuthor,
      'CountAttempts': instance.countAttempts,
      'Rating': instance.rating,
      'DifficultyMatch': instance.difficultyMatch,
      'AttemptCreatedAt': instance.attemptCreatedAt?.toIso8601String(),
      'TotalPercent': instance.totalPercent,
      'PronunciationPercent': instance.pronunciationPercent,
      'EnergyPercent': instance.energyPercent,
      'BreathPercent': instance.breathPercent,
      'EmotionPercent': instance.emotionPercent,
      'PitchPercent': instance.pitchPercent,
      'AudioSampleTstID': instance.audioSampleTstId,
      'PronunciationCompResultID': instance.pronunciationCompResultId,
      'PitchCompResultID': instance.pitchCompResultId,
      'EnergyCompResultID': instance.energyCompResultId,
      'BreathCompResultID': instance.breathCompResultId,
      'EmotionCompResultID': instance.emotionCompResultId,
    };
