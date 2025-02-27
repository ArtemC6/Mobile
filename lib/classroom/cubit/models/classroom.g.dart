// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'classroom.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Classroom _$ClassroomFromJson(Map<String, dynamic> json) => Classroom(
      id: json['ID'] as String,
      name: json['Name'] as String?,
      description: json['Description'] as String?,
      privacy: json['Privacy'] as String?,
      createdby: json['createdby'] as String?,
    );

Map<String, dynamic> _$ClassroomToJson(Classroom instance) => <String, dynamic>{
      'ID': instance.id,
      'Name': instance.name,
      'Description': instance.description,
      'Privacy': instance.privacy,
      'createdby': instance.createdby,
    };
