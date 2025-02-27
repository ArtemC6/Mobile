// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating(
      id: json['ID'] as String,
      createdAt: json['createdat'] == null
          ? null
          : DateTime.parse(json['createdat'] as String),
      createdBy: json['createdby'] as String?,
      objectId: json['ObjectID'] as String?,
      score: (json['Score'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'ID': instance.id,
      'createdat': instance.createdAt?.toIso8601String(),
      'createdby': instance.createdBy,
      'ObjectID': instance.objectId,
      'Score': instance.score,
    };
