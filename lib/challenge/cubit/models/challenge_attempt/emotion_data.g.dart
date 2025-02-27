// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'emotion_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmotionData _$EmotionDataFromJson(Map<String, dynamic> json) => EmotionData(
      frames: (json['frames'] as List<dynamic>)
          .map((e) => EmotionFrame.fromJson(e as Map<String, dynamic>))
          .toList(),
      comparePercent: (json['ComparePercent'] as num).toDouble(),
    );

Map<String, dynamic> _$EmotionDataToJson(EmotionData instance) =>
    <String, dynamic>{
      'frames': instance.frames,
      'ComparePercent': instance.comparePercent,
    };
