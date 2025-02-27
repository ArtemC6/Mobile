// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Element _$ElementFromJson(Map<String, dynamic> json) => Element(
      id: json['ID'] as String?,
      type: json['Type'] as String?,
      description: json['Description'] as String?,
      objectId: json['ObjectID'] as String?,
      objectName: json['ObjectName'] as String?,
      campusPlanId: json['CampusPlanID'] as String?,
      campusId: json['CampusID'] as String?,
      orderNum: (json['OrderNum'] as num?)?.toInt(),
      nextElementId: json['NextElementID'] as String?,
      finished: json['Finished'] as bool?,
      percent: json['Percent'],
    );

Map<String, dynamic> _$ElementToJson(Element instance) => <String, dynamic>{
      'ID': instance.id,
      'Type': instance.type,
      'Description': instance.description,
      'ObjectID': instance.objectId,
      'ObjectName': instance.objectName,
      'CampusPlanID': instance.campusPlanId,
      'CampusID': instance.campusId,
      'OrderNum': instance.orderNum,
      'NextElementID': instance.nextElementId,
      'Finished': instance.finished,
      'Percent': instance.percent,
    };
