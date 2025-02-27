// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'pass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pass _$PassFromJson(Map<String, dynamic> json) => Pass(
      id: json['ID'] as String?,
      createdat: json['createdat'] == null
          ? null
          : DateTime.parse(json['createdat'] as String),
      campusId: json['CampusID'] as String?,
      campusName: json['CampusName'] as String?,
      planId: json['PlanID'] as String?,
      planElementId: json['PlanElementID'] as String?,
      planName: json['PlanName'] as String?,
      planDescription: json['PlanDescription'] as String?,
      startAt: json['StartAt'] == null
          ? null
          : DateTime.parse(json['StartAt'] as String),
      endAt: json['EndAt'] == null
          ? null
          : DateTime.parse(json['EndAt'] as String),
      percent: json['Percent'],
    );

Map<String, dynamic> _$PassToJson(Pass instance) => <String, dynamic>{
      'ID': instance.id,
      'createdat': instance.createdat?.toIso8601String(),
      'CampusID': instance.campusId,
      'CampusName': instance.campusName,
      'PlanID': instance.planId,
      'PlanElementID': instance.planElementId,
      'PlanName': instance.planName,
      'PlanDescription': instance.planDescription,
      'StartAt': instance.startAt?.toIso8601String(),
      'EndAt': instance.endAt?.toIso8601String(),
      'Percent': instance.percent,
    };
