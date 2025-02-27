// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'fingerprint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fingerprint _$FingerprintFromJson(Map<String, dynamic> json) => Fingerprint(
      comparePercentPronunciation:
          (json['ComparePercentPronunciation'] as num?)?.toDouble() ?? 0,
      comparePercentPitch:
          (json['ComparePercentPitch'] as num?)?.toDouble() ?? 0,
      comparePercentEnergy:
          (json['ComparePercentEnergy'] as num?)?.toDouble() ?? 0,
      comparePercentBreath:
          (json['ComparePercentBreath'] as num?)?.toDouble() ?? 0,
      pronunciationCompResultId: json['PronunciationCompResultID'] as String,
      breathCompResultId: json['BreathCompResultID'] as String,
      pitchCompResultId: json['PitchCompResultID'] as String,
      energyCompResultId: json['EnergyCompResultID'] as String,
      audioSampleRefId: json['AudioSampleRefID'] as String,
      audioSampleTstId: json['AudioSampleTstID'] as String,
      error: json['error'] as String,
      fingerprintDataJoinedSegments34530eeb:
          FingerprintDataJoinedSegments34530eeb.fromJson(
              json['FingerprintDataJoinedSegments34530eeb']
                  as Map<String, dynamic>),
      xpAdd: (json['XPAdd'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FingerprintToJson(Fingerprint instance) =>
    <String, dynamic>{
      'ComparePercentPronunciation': instance.comparePercentPronunciation,
      'ComparePercentPitch': instance.comparePercentPitch,
      'ComparePercentEnergy': instance.comparePercentEnergy,
      'ComparePercentBreath': instance.comparePercentBreath,
      'PronunciationCompResultID': instance.pronunciationCompResultId,
      'BreathCompResultID': instance.breathCompResultId,
      'PitchCompResultID': instance.pitchCompResultId,
      'EnergyCompResultID': instance.energyCompResultId,
      'AudioSampleRefID': instance.audioSampleRefId,
      'AudioSampleTstID': instance.audioSampleTstId,
      'error': instance.error,
      'FingerprintDataJoinedSegments34530eeb':
          instance.fingerprintDataJoinedSegments34530eeb,
    };
