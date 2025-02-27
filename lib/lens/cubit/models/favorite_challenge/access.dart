import 'package:json_annotation/json_annotation.dart';

part 'access.g.dart';

@JsonSerializable()
class Access {
  Access({this.delete, this.read, this.update});

  factory Access.fromJson(Map<String, dynamic> json) {
    return _$AccessFromJson(json);
  }
  bool? delete;
  bool? read;
  bool? update;

  Map<String, dynamic> toJson() => _$AccessToJson(this);

  Access copyWith({
    bool? delete,
    bool? read,
    bool? update,
  }) {
    return Access(
      delete: delete ?? this.delete,
      read: read ?? this.read,
      update: update ?? this.update,
    );
  }
}
