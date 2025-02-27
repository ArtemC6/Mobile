// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Value _$ValueFromJson(Map<String, dynamic> json) => Value(
      int_: (json['Int'] as num?)?.toInt(),
      string: json['String'] as String?,
      bool_: json['Bool'] as bool?,
    );

Map<String, dynamic> _$ValueToJson(Value instance) => <String, dynamic>{
      'Int': instance.int_,
      'String': instance.string,
      'Bool': instance.bool_,
    };
