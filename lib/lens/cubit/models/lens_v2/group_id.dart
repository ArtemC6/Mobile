import 'package:json_annotation/json_annotation.dart';

part 'group_id.g.dart';

@JsonSerializable()
class GroupId {
  GroupId({
    this.groupId,
  });
  factory GroupId.fromJson(Map<String, dynamic> json) {
    return _$GroupIdFromJson(json);
  }
  @JsonKey(name: 'GroupID')
  String? groupId;

  Map<String, dynamic> toJson() => _$GroupIdToJson(this);
}
