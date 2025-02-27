// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'compare_level.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompareLevel _$CompareLevelFromJson(Map<String, dynamic> json) => CompareLevel(
      languageISO3: json['LanguageISO3'] as String?,
      languageName: json['LanguageName'] as String?,
      value: (json['Value'] as num?)?.toDouble(),
      isWorkLang: json['IsWorkLang'] as bool?,
    );

Map<String, dynamic> _$CompareLevelToJson(CompareLevel instance) =>
    <String, dynamic>{
      'LanguageISO3': instance.languageISO3,
      'LanguageName': instance.languageName,
      'Value': instance.value,
      'IsWorkLang': instance.isWorkLang,
    };
