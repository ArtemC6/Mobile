// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'mixer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MixerModel _$MixerModelFromJson(Map<String, dynamic> json) => MixerModel(
      mixerId: json['MixerID'] as String?,
      createdAt: json['CreatedAt'] == null
          ? null
          : DateTime.parse(json['CreatedAt'] as String),
      groupId: json['GroupID'] as String?,
      countItems: (json['CountItems'] as num?)?.toInt(),
      mixerItemId: json['MixerItemID'] as String?,
      orderNum: (json['OrderNum'] as num?)?.toDouble(),
      languageId: json['LanguageID'] as String?,
      audiosamplerefid: json['Audiosamplerefid'] as String?,
    );

Map<String, dynamic> _$MixerModelToJson(MixerModel instance) =>
    <String, dynamic>{
      'MixerID': instance.mixerId,
      'CreatedAt': instance.createdAt?.toIso8601String(),
      'GroupID': instance.groupId,
      'CountItems': instance.countItems,
      'MixerItemID': instance.mixerItemId,
      'OrderNum': instance.orderNum,
      'LanguageID': instance.languageId,
      'Audiosamplerefid': instance.audiosamplerefid,
    };
