import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable()
class Story extends Equatable {
  const Story({
    required this.id,
    required this.name,
    this.description,
    this.channelId,
    this.channelName,
    this.channelCreatedby,
    this.createdat,
    this.createdby,
  });

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
  Map<String, dynamic> toJson() => _$StoryToJson(this);

  @JsonKey(name: 'ID')
  final String id;
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'Description')
  final String? description;
  @JsonKey(name: 'ChannelID')
  final String? channelId;
  @JsonKey(name: 'ChannelName')
  final String? channelName;
  @JsonKey(name: 'ChannelCreatedBy')
  final String? channelCreatedby;
  final DateTime? createdat;
  final String? createdby;

  @override
  List<Object> get props => [id];
}
