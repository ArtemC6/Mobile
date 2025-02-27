// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'quiz_item_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizItemUpdate _$QuizItemUpdateFromJson(Map<String, dynamic> json) =>
    QuizItemUpdate(
      actId: json['ActID'] as String?,
      itemId: json['ItemID'] as String?,
      quiz: json['Quiz'] == null
          ? null
          : ItemPassQuiz.fromJson(json['Quiz'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuizItemUpdateToJson(QuizItemUpdate instance) =>
    <String, dynamic>{
      'ActID': instance.actId,
      'ItemID': instance.itemId,
      'Quiz': instance.quiz,
    };
