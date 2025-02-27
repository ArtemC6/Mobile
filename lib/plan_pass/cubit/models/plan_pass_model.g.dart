// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'plan_pass_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanPassPassModel _$PlanPassPassModelFromJson(Map<String, dynamic> json) =>
    PlanPassPassModel(
      id: json['ID'] as String?,
      campusId: json['CampusID'] as String?,
      planId: json['PlanID'] as String?,
      planElementId: json['PlanElementID'] as String?,
      planName: json['PlanName'] as String?,
      planDescription: json['PlanDescription'] as String?,
    );

Map<String, dynamic> _$PlanPassPassModelToJson(PlanPassPassModel instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'CampusID': instance.campusId,
      'PlanID': instance.planId,
      'PlanElementID': instance.planElementId,
      'PlanName': instance.planName,
      'PlanDescription': instance.planDescription,
    };

PlanPassElementModel _$PlanPassElementModelFromJson(
        Map<String, dynamic> json) =>
    PlanPassElementModel(
      id: json['ID'] as String?,
      type: json['Type'] as String?,
      description: json['Description'] as String?,
      other: json['Other'] as String?,
      objectId: json['ObjectID'] as String?,
      objectName: json['ObjectName'] as String?,
      campusPlanId: json['CampusPlanID'],
      campusId: json['CampusID'],
      orderNum: (json['OrderNum'] as num?)?.toInt(),
      nextElementId: json['NextElementID'],
    );

Map<String, dynamic> _$PlanPassElementModelToJson(
        PlanPassElementModel instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'Type': instance.type,
      'Description': instance.description,
      'Other': instance.other,
      'ObjectID': instance.objectId,
      'ObjectName': instance.objectName,
      'CampusPlanID': instance.campusPlanId,
      'CampusID': instance.campusId,
      'OrderNum': instance.orderNum,
      'NextElementID': instance.nextElementId,
    };

PlanPassModel _$PlanPassModelFromJson(Map<String, dynamic> json) =>
    PlanPassModel(
      pass: json['Pass'] == null
          ? null
          : PlanPassPassModel.fromJson(json['Pass'] as Map<String, dynamic>),
      elements: (json['Elements'] as List<dynamic>?)
          ?.map((e) => PlanPassElementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlanPassModelToJson(PlanPassModel instance) =>
    <String, dynamic>{
      'Pass': instance.pass,
      'Elements': instance.elements,
    };
