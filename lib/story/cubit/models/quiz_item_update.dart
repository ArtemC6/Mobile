import 'package:json_annotation/json_annotation.dart';
import 'package:voccent/story/cubit/models/item_pass_quiz.dart';

part 'quiz_item_update.g.dart';

@JsonSerializable()
class QuizItemUpdate {
  QuizItemUpdate({this.actId, this.itemId, this.quiz});

  factory QuizItemUpdate.fromJson(Map<String, dynamic> json) {
    return _$QuizItemUpdateFromJson(json);
  }

  Map<String, dynamic> toJson() => _$QuizItemUpdateToJson(this);

  @JsonKey(name: 'ActID')
  String? actId;
  @JsonKey(name: 'ItemID')
  String? itemId;
  @JsonKey(name: 'Quiz')
  ItemPassQuiz? quiz;

  QuizItemUpdate copyWith({
    String? actId,
    String? itemId,
    ItemPassQuiz? quiz,
  }) {
    return QuizItemUpdate(
      actId: actId ?? this.actId,
      itemId: itemId ?? this.itemId,
      quiz: quiz ?? this.quiz,
    );
  }
}
