// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'pronunciation_e1cbebc6.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PronunciationE1cbebc6 _$PronunciationE1cbebc6FromJson(
        Map<String, dynamic> json) =>
    PronunciationE1cbebc6(
      frames: (json['frames'] as List<dynamic>)
          .map((e) => Frame.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as List<dynamic>)
          .map((e) => Total.fromJson(e as Map<String, dynamic>))
          .toList(),
      dp: (json['dp'] as List<dynamic>)
          .map((e) => Dp.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PronunciationE1cbebc6ToJson(
        PronunciationE1cbebc6 instance) =>
    <String, dynamic>{
      'frames': instance.frames,
      'total': instance.total,
      'dp': instance.dp,
    };
