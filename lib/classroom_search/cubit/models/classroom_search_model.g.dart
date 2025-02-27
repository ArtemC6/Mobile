// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'classroom_search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassroomSearchModel _$ClassroomSearchModelFromJson(
        Map<String, dynamic> json) =>
    ClassroomSearchModel(
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
      languageIds: (json['LanguageIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      userStatus: json['UserStatus'] as String?,
      sourceLanguageGroup: (json['SourceLanguageGroup'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ClassroomSearchModelToJson(
        ClassroomSearchModel instance) =>
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
      'LanguageIDs': instance.languageIds,
      'UserStatus': instance.userStatus,
      'SourceLanguageGroup': instance.sourceLanguageGroup,
    };
