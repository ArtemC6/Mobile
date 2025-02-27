// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'annotation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Annotation _$AnnotationFromJson(Map<String, dynamic> json) => Annotation(
      segmentStart: (json['SegmentStart'] as num?)?.toDouble(),
      segmentEnd: (json['SegmentEnd'] as num?)?.toDouble(),
      transcription: json['Transcription'] as String?,
      description: json['Description'] as String?,
    );

Map<String, dynamic> _$AnnotationToJson(Annotation instance) =>
    <String, dynamic>{
      'SegmentStart': instance.segmentStart,
      'SegmentEnd': instance.segmentEnd,
      'Transcription': instance.transcription,
      'Description': instance.description,
    };
