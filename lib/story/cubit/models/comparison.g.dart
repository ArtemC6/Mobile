// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'comparison.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comparison _$ComparisonFromJson(Map<String, dynamic> json) => Comparison(
      actId: json['ActID'] as String?,
      audioId: json['AudioID'] as String?,
      compareEmotionPercent:
          (json['CompareEmotionPercent'] as num?)?.toDouble(),
      compareBreathPercent: (json['CompareBreathPercent'] as num?)?.toDouble(),
      compareEnergyPercent: (json['CompareEnergyPercent'] as num?)?.toDouble(),
      comparePercent: (json['ComparePercent'] as num?)?.toDouble(),
      comparePitchPercent: (json['ComparePitchPercent'] as num?)?.toDouble(),
      comparePronunciationPercent:
          (json['ComparePronunciationPercent'] as num?)?.toDouble(),
      itemId: json['ItemID'] as String?,
      xpAdd: (json['XPAdd'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ComparisonToJson(Comparison instance) =>
    <String, dynamic>{
      'ActID': instance.actId,
      'AudioID': instance.audioId,
      'CompareEmotionPercent': instance.compareEmotionPercent,
      'CompareBreathPercent': instance.compareBreathPercent,
      'CompareEnergyPercent': instance.compareEnergyPercent,
      'ComparePercent': instance.comparePercent,
      'ComparePitchPercent': instance.comparePitchPercent,
      'ComparePronunciationPercent': instance.comparePronunciationPercent,
      'ItemID': instance.itemId,
      'XPAdd': instance.xpAdd,
    };
