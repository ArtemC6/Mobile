import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story_pass.g.dart';

@JsonSerializable()
class StoryPass extends Equatable {
  const StoryPass({
    this.id,
    this.link,
    this.storyId,
    this.storyParentId,
    this.status,
    this.actId,
    this.actItemId,
    this.condition,
    this.progress = 0,
    this.pause,
    this.type,
    this.levels,
    this.actItemNumber,
    this.actItems,
    this.progressAct,
    this.levelNumber,
  });

  factory StoryPass.fromJson(Map<String, dynamic> json) =>
      _$StoryPassFromJson(json);
  Map<String, dynamic> toJson() => _$StoryPassToJson(this);

  @JsonKey(name: 'ID')
  final String? id;
  @JsonKey(name: 'Link')
  final String? link;
  @JsonKey(name: 'StoryID')
  final String? storyId;
  @JsonKey(name: 'StoryParentID')
  final String? storyParentId;
  @JsonKey(name: 'Status')
  final String? status;
  @JsonKey(name: 'ActID')
  final String? actId;
  @JsonKey(name: 'ActItemID')
  final String? actItemId;
  @JsonKey(name: 'Condition')
  final bool? condition;
  @JsonKey(name: 'Progress')
  final double progress;
  @JsonKey(name: 'Pause')
  final bool? pause;
  @JsonKey(name: 'Type')
  final int? type;
  @JsonKey(name: 'Levels')
  final int? levels;
  @JsonKey(name: 'ActItemNumber')
  final int? actItemNumber;
  @JsonKey(name: 'ActItems')
  final int? actItems;
  @JsonKey(name: 'ProgressAct')
  final double? progressAct;
  @JsonKey(name: 'LevelNumber')
  final int? levelNumber;

  StoryPass copyWith({
    String? id,
    String? link,
    String? storyId,
    String? storyParentId,
    String? status,
    String? actId,
    String? actItemId,
    bool? condition,
    double? progress,
    bool? pause,
    int? type,
    int? levels,
    int? actItemNumber,
    int? actItems,
    double? progressAct,
    int? levelNumber,
  }) {
    return StoryPass(
      id: id ?? this.id,
      link: link ?? this.link,
      storyId: storyId ?? this.storyId,
      storyParentId: storyParentId ?? this.storyParentId,
      status: status ?? this.status,
      actId: actId ?? this.actId,
      actItemId: actItemId ?? this.actItemId,
      condition: condition ?? this.condition,
      progress: progress ?? this.progress,
      pause: pause ?? this.pause,
      type: type ?? this.type,
      levels: levels ?? this.levels,
      actItemNumber: actItemNumber ?? this.actItemNumber,
      actItems: actItems ?? this.actItems,
      progressAct: progressAct ?? this.progressAct,
      levelNumber: levelNumber ?? this.levelNumber,
    );
  }

  @override
  List<Object?> get props => [
        id,
        link,
        storyId,
        storyParentId,
        status,
        actId,
        actItemId,
        condition,
        progress,
        pause,
        type,
        levels,
        actItemNumber,
        actItems,
        progressAct,
        levelNumber,
      ];
}
