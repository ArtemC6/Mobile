// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'finished_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinishedPlan _$FinishedPlanFromJson(Map<String, dynamic> json) => FinishedPlan(
      pass: json['Pass'] == null
          ? null
          : Pass.fromJson(json['Pass'] as Map<String, dynamic>),
      elements: (json['Elements'] as List<dynamic>?)
          ?.map((e) => Element.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FinishedPlanToJson(FinishedPlan instance) =>
    <String, dynamic>{
      'Pass': instance.pass,
      'Elements': instance.elements,
    };
