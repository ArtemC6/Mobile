// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'classroom_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassroomObject _$ClassroomObjectFromJson(Map<String, dynamic> json) =>
    ClassroomObject(
      classroom: json['Classroom'] == null
          ? null
          : Classroom.fromJson(json['Classroom'] as Map<String, dynamic>),
      confirmation: json['Confirmation'] == null
          ? null
          : Confirmation.fromJson(json['Confirmation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClassroomObjectToJson(ClassroomObject instance) =>
    <String, dynamic>{
      'Classroom': instance.classroom,
      'Confirmation': instance.confirmation,
    };
