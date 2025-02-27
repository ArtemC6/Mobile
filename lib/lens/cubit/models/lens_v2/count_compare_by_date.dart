import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'count_compare_by_date.g.dart';

@JsonSerializable()
class CountCompareByDate extends Equatable {
  const CountCompareByDate({
    this.date,
    this.count,
  });

  factory CountCompareByDate.fromJson(Map<String, dynamic> json) =>
      _$CountCompareByDateFromJson(json);
  @JsonKey(name: 'Date')
  final String? date;
  @JsonKey(name: 'Count')
  final int? count;

  Map<String, dynamic> toJson() => _$CountCompareByDateToJson(this);

  CountCompareByDate copyWith({
    String? date,
    int? count,
  }) {
    return CountCompareByDate(
      date: date ?? this.date,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [date, count];
}
