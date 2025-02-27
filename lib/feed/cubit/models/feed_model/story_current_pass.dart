import 'package:json_annotation/json_annotation.dart';

part 'story_current_pass.g.dart';

@JsonSerializable()
class StoryCurrentPass {
  StoryCurrentPass({this.link});

  factory StoryCurrentPass.fromJson(Map<String, dynamic> json) {
    return _$StoryCurrentPassFromJson(json);
  }
  @JsonKey(name: 'Link')
  String? link;

  Map<String, dynamic> toJson() => _$StoryCurrentPassToJson(this);
}
