// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['ID'] as String? ?? '',
      name: json['Name'] as String? ?? '',
      fullName: json['FullName'] as String? ?? '',
      objectID: json['ObjectID'] as String? ?? '',
      children: (json['Children'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Category>[],
      orderNum: (json['OrderNum'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'ID': instance.id,
      'Name': instance.name,
      'FullName': instance.fullName,
      'ObjectID': instance.objectID,
      'Children': instance.children,
      'OrderNum': instance.orderNum,
    };
