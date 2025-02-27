import 'package:json_annotation/json_annotation.dart';
import 'package:voccent/chat/cubit/models/message/meta.dart';

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
