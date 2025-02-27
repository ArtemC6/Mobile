import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'compare_level.g.dart';

@JsonSerializable()
class CompareLevel extends Equatable {
  const CompareLevel({
    this.languageISO3,
    this.languageName,
    this.value,
    this.isWorkLang,
  });

  factory CompareLevel.fromJson(Map<String, dynamic> json) =>
      _$CompareLevelFromJson(json);
  @JsonKey(name: 'LanguageISO3')
  final String? languageISO3;
  @JsonKey(name: 'LanguageName')
  final String? languageName;
  @JsonKey(name: 'Value')
  final double? value;
  @JsonKey(name: 'IsWorkLang')
  final bool? isWorkLang;

  Map<String, dynamic> toJson() => _$CompareLevelToJson(this);

  CompareLevel copyWith({
    String? languageISO3,
    String? languageName,
    double? value,
    bool? isWorkLang,
  }) {
    return CompareLevel(
      languageISO3: languageISO3 ?? this.languageISO3,
      languageName: languageName ?? this.languageName,
      value: value ?? this.value,
      isWorkLang: isWorkLang ?? this.isWorkLang,
    );
  }

  @override
  List<Object?> get props => [languageISO3, languageName, value, isWorkLang];
}
