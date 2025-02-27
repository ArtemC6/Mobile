// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Frame _$FrameFromJson(Map<String, dynamic> json) => Frame(
      segmentStart: (json['SegmentStart'] as num?)?.toDouble() ?? 0,
      segmentEnd: (json['SegmentEnd'] as num?)?.toDouble() ?? 0,
      breath: (json['Breath'] as num?)?.toDouble() ?? 0,
      energy: (json['Energy'] as num?)?.toDouble() ?? 0,
      pitch: (json['Pitch'] as num?)?.toDouble() ?? 0,
      anMmfcc: (json['AnMMFCC'] as num?)?.toDouble() ?? 0,
      anMplp: (json['AnMPLP'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$FrameToJson(Frame instance) => <String, dynamic>{
      'SegmentStart': instance.segmentStart,
      'SegmentEnd': instance.segmentEnd,
      'Breath': instance.breath,
      'Energy': instance.energy,
      'Pitch': instance.pitch,
      'AnMMFCC': instance.anMmfcc,
      'AnMPLP': instance.anMplp,
    };
