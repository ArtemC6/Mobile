import 'package:json_annotation/json_annotation.dart';

part 'user_language.g.dart';

@JsonSerializable()
class UserLanguage {
  const UserLanguage({
    this.id = '',
    this.name = '',
  });

  const UserLanguage.english()
      : this(id: '00000000-0000-0000-0000-000000000001', name: 'English');

  factory UserLanguage.fromJson(Map<String, dynamic> json) =>
      _$UserLanguageFromJson(json);
  Map<String, dynamic> toJson() => _$UserLanguageToJson(this);

  @JsonKey(name: 'languageid')
  final String id;

  @JsonKey(name: 'languagename')
  final String name;

  @override
  String toString() {
    return 'lang-$id';
  }
}
