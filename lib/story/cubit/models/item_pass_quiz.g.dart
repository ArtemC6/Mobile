// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'item_pass_quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemPassQuiz _$ItemPassQuizFromJson(Map<String, dynamic> json) => ItemPassQuiz(
      percent: (json['Percent'] as num?)?.toDouble(),
      quizId:
          (json['QuizID'] as List<dynamic>?)?.map((e) => e as String).toList(),
      quizText: (json['QuizText'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
    );

Map<String, dynamic> _$ItemPassQuizToJson(ItemPassQuiz instance) =>
    <String, dynamic>{
      'QuizID': instance.quizId,
      'QuizText': instance.quizText,
      'Percent': instance.percent,
    };
