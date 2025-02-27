import 'package:json_annotation/json_annotation.dart';
import 'package:voccent/activity_chat/cubit/models/messages/meta.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  Message({
    this.id,
    this.createdat,
    this.createdby,
    this.username,
    this.meta = const [],
  });
  factory Message.fromJson(Map<String, dynamic> json) {
    return _$MessageFromJson(json);
  }

  Message copyWith({
    String? id,
    String? createdat,
    String? createdby,
    String? username,
    List<Meta>? meta,
  }) {
    return Message(
      id: id ?? this.id,
      createdat: createdat ?? this.createdat,
      createdby: createdby ?? this.createdby,
      username: username ?? this.username,
      meta: meta ?? this.meta,
    );
  }

  @JsonKey(name: 'ID')
  String? id;
  String? createdat;
  String? createdby;
  @JsonKey(name: 'Username')
  String? username;
  @JsonKey(name: 'Meta')
  List<Meta> meta;

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  String toString() {
    return 'msg-$id';
  }
}
