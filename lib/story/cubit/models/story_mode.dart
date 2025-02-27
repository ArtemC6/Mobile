import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story_mode.g.dart';

@JsonSerializable()
class StoryMode extends Equatable {
  const StoryMode({
    required this.id,
    required this.type,
  });

  factory StoryMode.fromJson(Map<String, dynamic> json) =>
      _$StoryModeFromJson(json);
  Map<String, dynamic> toJson() => _$StoryModeToJson(this);

  @JsonKey(name: 'ID')
  final String id;
  @JsonKey(name: 'Type')
  final int type;

  @override
  List<Object> get props => [id, type];
}
