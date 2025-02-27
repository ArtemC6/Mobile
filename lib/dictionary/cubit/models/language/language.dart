import 'package:json_annotation/json_annotation.dart';
import 'package:voccent/home/cubit/models/user/user_language.dart';

part 'language.g.dart';

@JsonSerializable()
class Language {
  Language({
    this.name,
    this.iso2,
    this.iso3,
    this.code,
    this.locale,
    this.currencyCode,
    this.id = '00000000-0000-0000-0000-000000000001',
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return _$LanguageFromJson(json);
  }

  String? name;
  @JsonKey(name: 'iso_2')
  String? iso2;
  @JsonKey(name: 'iso_3')
  String? iso3;
  String? code;
  String? locale;
  @JsonKey(name: 'currency_code')
  dynamic currencyCode;
  @JsonKey(name: 'ID')
  String id;

  Map<String, dynamic> toJson() => _$LanguageToJson(this);

  @override
  String toString() {
    return 'lng-$name';
  }

  UserLanguage toUserLanguage() {
    return UserLanguage(id: id, name: name ?? '8efbfde4');
  }

  Language copyWith({
    String? name,
    String? iso2,
    String? iso3,
    String? code,
    String? locale,
    dynamic currencyCode,
    String? id,
  }) {
    return Language(
      name: name ?? this.name,
      iso2: iso2 ?? this.iso2,
      iso3: iso3 ?? this.iso3,
      code: code ?? this.code,
      locale: locale ?? this.locale,
      currencyCode: currencyCode ?? this.currencyCode,
      id: id ?? this.id,
    );
  }
}
