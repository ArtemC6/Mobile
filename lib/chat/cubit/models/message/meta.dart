import 'package:json_annotation/json_annotation.dart';

part 'meta.g.dart';

@JsonSerializable()
class Meta {
  Meta({
    this.id,
    this.body,
    this.chatId,
    this.messageId,
    this.objectId,
    this.orderNum,
    this.type,
    this.payload,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return _$MetaFromJson(json);
  }

  @JsonKey(name: 'ID')
  String? id;
  @JsonKey(name: 'Body')
  String? body;
  @JsonKey(name: 'ChatID')
  String? chatId;
  @JsonKey(name: 'MessageID')
  String? messageId;
  @JsonKey(name: 'ObjectID')
  String? objectId;
  @JsonKey(name: 'OrderNum')
  int? orderNum;
  @JsonKey(name: 'Type')
  String? type;
  @JsonKey(name: 'Payload')
  String? payload;

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
