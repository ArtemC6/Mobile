// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'dp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dp _$DpFromJson(Map<String, dynamic> json) => Dp(
      segmentStartTest: (json['SegmentStartTest'] as num).toDouble(),
      segmentEndTest: (json['SegmentEndTest'] as num).toDouble(),
      segmentStartRef: (json['SegmentStartRef'] as num).toDouble(),
      segmentEndRef: (json['SegmentEndRef'] as num).toDouble(),
    );

Map<String, dynamic> _$DpToJson(Dp instance) => <String, dynamic>{
      'SegmentStartTest': instance.segmentStartTest,
      'SegmentEndTest': instance.segmentEndTest,
      'SegmentStartRef': instance.segmentStartRef,
      'SegmentEndRef': instance.segmentEndRef,
    };
