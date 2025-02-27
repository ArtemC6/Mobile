// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'frames_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FramesData _$FramesDataFromJson(Map<String, dynamic> json) => FramesData(
      frames: (json['frames'] as List<dynamic>?)
          ?.map((e) => Frame.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FramesDataToJson(FramesData instance) =>
    <String, dynamic>{
      'frames': instance.frames,
    };
