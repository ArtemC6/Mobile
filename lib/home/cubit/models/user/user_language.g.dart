// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'user_language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLanguage _$UserLanguageFromJson(Map<String, dynamic> json) => UserLanguage(
      id: json['languageid'] as String? ?? '',
      name: json['languagename'] as String? ?? '',
    );

Map<String, dynamic> _$UserLanguageToJson(UserLanguage instance) =>
    <String, dynamic>{
      'languageid': instance.id,
      'languagename': instance.name,
    };
