// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'prosody_c7f1eb37.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProsodyC7f1eb37 _$ProsodyC7f1eb37FromJson(Map<String, dynamic> json) =>
    ProsodyC7f1eb37(
      frames: (json['frames'] as List<dynamic>)
          .map((e) => Frame.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as List<dynamic>)
          .map((e) => Total.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProsodyC7f1eb37ToJson(ProsodyC7f1eb37 instance) =>
    <String, dynamic>{
      'frames': instance.frames,
      'total': instance.total,
    };
