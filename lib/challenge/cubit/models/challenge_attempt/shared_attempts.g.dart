// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'shared_attempts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedAttempt _$SharedAttemptFromJson(Map<String, dynamic> json) =>
    SharedAttempt(
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
      audioSampleRefId: json['AudioSampleRefID'],
      ipaCompResultId: json['IpaCompResultID'] as String?,
      pitchCompResultId: json['PitchCompResultID'] as String?,
      energyCompResultId: json['EnergyCompResultID'] as String?,
      breathCompResultId: json['BreathCompResultID'] as String?,
      emotionCompResultId: json['EmotionCompResultID'] as String?,
      pronunciationPercent: (json['PronunciationPercent'] as num?)?.toDouble(),
      pitchPercent: (json['PitchPercent'] as num?)?.toDouble(),
      energyPercent: (json['EnergyPercent'] as num?)?.toDouble(),
      breathPercent: (json['BreathPercent'] as num?)?.toDouble(),
      emotionPercent: (json['EmotionPercent'] as num?)?.toDouble(),
      totalPercent: (json['TotalPercent'] as num?)?.toDouble(),
      difficulty: (json['Difficulty'] as num?)?.toDouble(),
      level: json['Level'],
      xpAdd: json['XPAdd'],
      xpFactorAdd: json['XPFactorAdd'],
      xpTotal: json['XPTotal'],
      xpFactorCurrent: json['XPFactorCurrent'],
      shareAll: (json['ShareAll'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      shareAuthor: json['ShareAuthor'],
      isShareVoice: json['IsShareVoice'] as bool?,
      userName: json['UserName'] as String?,
    );

Map<String, dynamic> _$SharedAttemptToJson(SharedAttempt instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'createdat': instance.createdat?.toIso8601String(),
      'updatedat': instance.updatedat?.toIso8601String(),
      'createdby': instance.createdby,
      'ChallengeID': instance.challengeId,
      'PronunciationCompResultID': instance.pronunciationCompResultId,
      'AudioSampleTstID': instance.audioSampleTstId,
      'AudioSampleRefID': instance.audioSampleRefId,
      'IpaCompResultID': instance.ipaCompResultId,
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
      'Difficulty': instance.difficulty,
      'Level': instance.level,
      'XPAdd': instance.xpAdd,
      'XPFactorAdd': instance.xpFactorAdd,
      'XPTotal': instance.xpTotal,
      'XPFactorCurrent': instance.xpFactorCurrent,
      'ShareAll': instance.shareAll,
      'ShareAuthor': instance.shareAuthor,
      'IsShareVoice': instance.isShareVoice,
      'UserName': instance.userName,
    };
