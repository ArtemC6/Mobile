// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'capability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Capability _$CapabilityFromJson(Map<String, dynamic> json) => Capability(
      id: json['ID'] as String?,
      name: json['Name'] as String?,
      type: json['Type'] as String?,
    );

Map<String, dynamic> _$CapabilityToJson(Capability instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'Name': instance.name,
      'Type': instance.type,
    };
