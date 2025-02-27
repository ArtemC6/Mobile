// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'my_classrooms_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyClassroom _$MyClassroomFromJson(Map<String, dynamic> json) => MyClassroom(
      id: json['ID'] as String?,
      createdat: json['createdat'] == null
          ? null
          : DateTime.parse(json['createdat'] as String),
      updatedat: json['updatedat'] == null
          ? null
          : DateTime.parse(json['updatedat'] as String),
      createdby: json['createdby'] as String?,
      updatedby: json['updatedby'] as String?,
      name: json['Name'] as String?,
      description: json['Description'] as String?,
      members: (json['Members'] as num?)?.toInt(),
      plans: (json['Plans'] as num?)?.toInt(),
      countRating: (json['CountRating'] as num?)?.toInt(),
      rating: (json['Rating'] as num?)?.toDouble(),
      autoAccept: json['AutoAccept'] as bool?,
      userStatus: json['UserStatus'] as String?,
      sourceLanguageID: json['SourceLanguageID'] as String?,
    );

Map<String, dynamic> _$MyClassroomToJson(MyClassroom instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'createdat': instance.createdat?.toIso8601String(),
      'updatedat': instance.updatedat?.toIso8601String(),
      'createdby': instance.createdby,
      'updatedby': instance.updatedby,
      'Name': instance.name,
      'Description': instance.description,
      'Members': instance.members,
      'Plans': instance.plans,
      'CountRating': instance.countRating,
      'Rating': instance.rating,
      'AutoAccept': instance.autoAccept,
      'UserStatus': instance.userStatus,
      'SourceLanguageID': instance.sourceLanguageID,
    };
