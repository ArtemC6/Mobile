// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'emotion_frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmotionFrame _$EmotionFrameFromJson(Map<String, dynamic> json) => EmotionFrame(
      segmentStart: (json['SegmentStart'] as num).toDouble(),
      segmentEnd: (json['SegmentEnd'] as num).toDouble(),
      valenceRef: (json['valence_ref'] as num).toDouble(),
      arousalRef: (json['arousal_ref'] as num).toDouble(),
      valenceTest: (json['valence_test'] as num).toDouble(),
      arousalTest: (json['arousal_test'] as num).toDouble(),
    );

Map<String, dynamic> _$EmotionFrameToJson(EmotionFrame instance) =>
    <String, dynamic>{
      'SegmentStart': instance.segmentStart,
      'SegmentEnd': instance.segmentEnd,
      'valence_ref': instance.valenceRef,
      'arousal_ref': instance.arousalRef,
      'valence_test': instance.valenceTest,
      'arousal_test': instance.arousalTest,
    };
