import 'package:json_annotation/json_annotation.dart';

import 'package:voccent/chat/cubit/models/chat/user.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
  Chat({
    this.createdBy,
    this.id,
    this.messageStatus,
    this.objectCtreatedBy,
    this.objectId,
    this.subjectName,
    this.type,
    this.users,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  @JsonKey(name: 'CreatedBy')
  String? createdBy;
  @JsonKey(name: 'ID')
  String? id;
  @JsonKey(name: 'MessageStatus')
  String? messageStatus;
  @JsonKey(name: 'ObjectCtreatedBy')
  String? objectCtreatedBy;
  @JsonKey(name: 'ObjectID')
  String? objectId;
  @JsonKey(name: 'SubjectName')
  String? subjectName;
  @JsonKey(name: 'Type')
  String? type;
  @JsonKey(name: 'Users')
  List<User>? users;

  String get firstFourUsernames {
    if (users == null) {
      return '';
    }

    final sb = StringBuffer();

    for (var i = 0; i < 4 && i < users!.length; i++) {
      sb.write(users![i].name);
      // ignore: cascade_invocations
      sb.write(', ');
    }

    if (sb.length > 1) {
      return sb.toString().substring(0, sb.length - 2);
    }

    return sb.toString();
  }

  String? get firstUserpic {
    if (users == null || users!.isEmpty) {
      return null;
    }

    return '/api/v1/asset/file/user_avatar/${users!.first.id!}';
  }

  Map<String, dynamic> toJson() => _$ChatToJson(this);

  @override
  String toString() {
    return 'chat-$id';
  }
}
