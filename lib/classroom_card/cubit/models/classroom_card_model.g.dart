// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'classroom_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassroomCardClassroomModel _$ClassroomCardClassroomModelFromJson(
        Map<String, dynamic> json) =>
    ClassroomCardClassroomModel(
      id: json['ID'] as String?,
      createdat: json['createdat'] == null
          ? null
          : DateTime.parse(json['createdat'] as String),
      createdby: json['createdby'] as String?,
      name: json['Name'] as String?,
      description: json['Description'] as String?,
      members: (json['Members'] as num?)?.toInt(),
      plans: (json['Plans'] as num?)?.toInt(),
      rating: (json['Rating'] as num?)?.toDouble(),
      countRating: (json['CountRating'] as num?)?.toInt(),
      autoAccept: json['AutoAccept'] as bool?,
    );

Map<String, dynamic> _$ClassroomCardClassroomModelToJson(
        ClassroomCardClassroomModel instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'createdat': instance.createdat?.toIso8601String(),
      'createdby': instance.createdby,
      'Name': instance.name,
      'Description': instance.description,
      'Members': instance.members,
      'Plans': instance.plans,
      'Rating': instance.rating,
      'CountRating': instance.countRating,
      'AutoAccept': instance.autoAccept,
    };

ClassroomCardConfirmationModel _$ClassroomCardConfirmationModelFromJson(
        Map<String, dynamic> json) =>
    ClassroomCardConfirmationModel(
      status: json['Status'] as String?,
    );

Map<String, dynamic> _$ClassroomCardConfirmationModelToJson(
        ClassroomCardConfirmationModel instance) =>
    <String, dynamic>{
      'Status': instance.status,
    };

ClassroomCardPlanModel _$ClassroomCardPlanModelFromJson(
        Map<String, dynamic> json) =>
    ClassroomCardPlanModel(
      classroomId: json['ID'] as String?,
      createdat: json['createdat'] == null
          ? null
          : DateTime.parse(json['createdat'] as String),
      createdby: json['createdby'] as String?,
      name: json['Name'] as String?,
      description: json['Description'] as String?,
      elementCount: (json['ElementCount'] as num?)?.toInt(),
      campusName: json['CampusName'] as String?,
      startAt: json['StartAt'] == null
          ? null
          : DateTime.parse(json['StartAt'] as String),
      endAt: json['EndAt'] == null
          ? null
          : DateTime.parse(json['EndAt'] as String),
      userPassing: json['UserPassing'] as bool?,
      planId: json['PlanID'] as String?,
      userPassingScore: (json['UserPassingScore'] as num?)?.toDouble(),
      userPassedTopScore: (json['UserPassedTopScore'] as num?)?.toDouble(),
      orderNum: (json['OrderNum'] as num?)?.toInt(),
      monetization: json['Monetization'] as bool?,
    );

Map<String, dynamic> _$ClassroomCardPlanModelToJson(
        ClassroomCardPlanModel instance) =>
    <String, dynamic>{
      'ID': instance.classroomId,
      'createdat': instance.createdat?.toIso8601String(),
      'createdby': instance.createdby,
      'Name': instance.name,
      'Description': instance.description,
      'ElementCount': instance.elementCount,
      'CampusName': instance.campusName,
      'StartAt': instance.startAt?.toIso8601String(),
      'EndAt': instance.endAt?.toIso8601String(),
      'UserPassing': instance.userPassing,
      'UserPassingScore': instance.userPassingScore,
      'PlanID': instance.planId,
      'UserPassedTopScore': instance.userPassedTopScore,
      'OrderNum': instance.orderNum,
      'Monetization': instance.monetization,
    };

ClassroomCardModel _$ClassroomCardModelFromJson(Map<String, dynamic> json) =>
    ClassroomCardModel(
      classroom: json['Classroom'] == null
          ? null
          : ClassroomCardClassroomModel.fromJson(
              json['Classroom'] as Map<String, dynamic>),
      languageIds: (json['LanguageIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      confirmation: json['Confirmation'] == null
          ? null
          : ClassroomCardConfirmationModel.fromJson(
              json['Confirmation'] as Map<String, dynamic>),
      currentPlans: (json['CurrentPlans'] as List<dynamic>?)
          ?.map(
              (e) => ClassroomCardPlanModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ClassroomCardModelToJson(ClassroomCardModel instance) =>
    <String, dynamic>{
      'Classroom': instance.classroom,
      'LanguageIDs': instance.languageIds,
      'Confirmation': instance.confirmation,
      'CurrentPlans': instance.currentPlans,
    };
