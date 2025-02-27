import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_pass_quiz.g.dart';

@JsonSerializable()
class ItemPassQuiz extends Equatable {
  const ItemPassQuiz({this.percent, this.quizId, this.quizText});

  factory ItemPassQuiz.fromJson(Map<String, dynamic> json) {
    return _$ItemPassQuizFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ItemPassQuizToJson(this);

  @JsonKey(name: 'QuizID')
  final List<String>? quizId;
  @JsonKey(name: 'QuizText')
  final List<String?>? quizText;
  @JsonKey(name: 'Percent')
  final double? percent;

  String? get percentString {
    if (percent == null) {
      return null;
    }

    return NumberFormat("##'%").format(percent);
  }

  bool get isNotEmpty =>
      (quizId?.isNotEmpty ?? false) || (quizText?.isNotEmpty ?? false);

  ItemPassQuiz copyWith({
    List<String>? quizId,
    List<String?>? quizText,
    double? percent,
  }) {
    return ItemPassQuiz(
      quizId: quizId ?? this.quizId,
      quizText: quizText ?? this.quizText,
      percent: percent ?? this.percent,
    );
  }

  @override
  List<Object?> get props => [quizId, quizText, percent];
}
