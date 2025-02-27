// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'breath22cbbd85.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Breath22cbbd85 _$Breath22cbbd85FromJson(Map<String, dynamic> json) =>
    Breath22cbbd85(
      frames: (json['frames'] as List<dynamic>)
          .map((e) => Frame.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as List<dynamic>)
          .map((e) => Total.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$Breath22cbbd85ToJson(Breath22cbbd85 instance) =>
    <String, dynamic>{
      'frames': instance.frames,
      'total': instance.total,
    };
