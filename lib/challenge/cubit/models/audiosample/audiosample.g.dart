// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'audiosample.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Audiosample _$AudiosampleFromJson(Map<String, dynamic> json) => Audiosample(
      label: json['Label'] as String?,
      isRef: json['IsRef'] as bool?,
      isPublic: json['IsPublic'],
      isShared: json['IsShared'],
      typeId: json['TypeID'] as String?,
      annotations: (json['Annotations'] as List<dynamic>?)
          ?.map((e) => Annotation.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['ID'] as String?,
    );

Map<String, dynamic> _$AudiosampleToJson(Audiosample instance) =>
    <String, dynamic>{
      'Label': instance.label,
      'IsRef': instance.isRef,
      'IsPublic': instance.isPublic,
      'IsShared': instance.isShared,
      'TypeID': instance.typeId,
      'Annotations': instance.annotations,
      'ID': instance.id,
    };
