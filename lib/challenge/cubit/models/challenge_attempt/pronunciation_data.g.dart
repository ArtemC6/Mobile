// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'pronunciation_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PronunciationData _$PronunciationDataFromJson(Map<String, dynamic> json) =>
    PronunciationData(
      frames: (json['frames'] as List<dynamic>?)
          ?.map((e) => Frame.fromJson(e as Map<String, dynamic>))
          .toList(),
      dp: (json['dp'] as List<dynamic>?)
          ?.map((e) => Dp.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PronunciationDataToJson(PronunciationData instance) =>
    <String, dynamic>{
      'frames': instance.frames,
      'dp': instance.dp,
    };
