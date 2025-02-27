// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'access.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Access _$AccessFromJson(Map<String, dynamic> json) => Access(
      delete: json['delete'] as bool?,
      read: json['read'] as bool?,
      update: json['update'] as bool?,
    );

Map<String, dynamic> _$AccessToJson(Access instance) => <String, dynamic>{
      'delete': instance.delete,
      'read': instance.read,
      'update': instance.update,
    };
