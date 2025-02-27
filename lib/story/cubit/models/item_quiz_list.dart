import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_quiz_list.g.dart';

@JsonSerializable()
class ItemQuizList extends Equatable {
  const ItemQuizList({this.id, this.orderNum, this.variant});

  factory ItemQuizList.fromJson(Map<String, dynamic> json) {
    return _$ItemQuizListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ItemQuizListToJson(this);

  @JsonKey(name: 'ID')
  final String? id;
  @JsonKey(name: 'OrderNum')
  final int? orderNum;
  @JsonKey(name: 'Variant')
  final String? variant;

  ItemQuizList copyWith({
    String? id,
    int? orderNum,
    String? variant,
  }) {
    return ItemQuizList(
      id: id ?? this.id,
      orderNum: orderNum ?? this.orderNum,
      variant: variant ?? this.variant,
    );
  }

  @override
  List<Object?> get props => [id, orderNum, variant];
}
