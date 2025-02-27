// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'streamotion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreamotionCompareModel _$StreamotionCompareModelFromJson(
        Map<String, dynamic> json) =>
    StreamotionCompareModel(
      num: (json['Num'] as num?)?.toInt(),
      valence: (json['Valence'] as num?)?.toDouble() ?? 0,
      arousal: (json['Arousal'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$StreamotionCompareModelToJson(
        StreamotionCompareModel instance) =>
    <String, dynamic>{
      'Num': instance.num,
      'Valence': instance.valence,
      'Arousal': instance.arousal,
    };
