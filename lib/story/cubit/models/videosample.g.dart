// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'videosample.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Videosample _$VideosampleFromJson(Map<String, dynamic> json) => Videosample(
      duration: (json['Duration'] as num?)?.toDouble(),
      typeId: json['TypeID'] as String?,
      loop: json['Loop'] as bool?,
      volume: (json['Volume'] as num?)?.toDouble(),
      objectId: json['ObjectID'] as String?,
      objectType: json['ObjectType'] as String?,
      id: json['ID'] as String?,
      createdby: json['createdby'] as String?,
    );

Map<String, dynamic> _$VideosampleToJson(Videosample instance) =>
    <String, dynamic>{
      'Duration': instance.duration,
      'TypeID': instance.typeId,
      'Loop': instance.loop,
      'Volume': instance.volume,
      'ObjectID': instance.objectId,
      'ObjectType': instance.objectType,
      'ID': instance.id,
      'createdby': instance.createdby,
    };
