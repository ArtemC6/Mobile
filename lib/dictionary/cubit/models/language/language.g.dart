// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Language _$LanguageFromJson(Map<String, dynamic> json) => Language(
      name: json['name'] as String?,
      iso2: json['iso_2'] as String?,
      iso3: json['iso_3'] as String?,
      code: json['code'] as String?,
      locale: json['locale'] as String?,
      currencyCode: json['currency_code'],
      id: json['ID'] as String? ?? '00000000-0000-0000-0000-000000000001',
    );

Map<String, dynamic> _$LanguageToJson(Language instance) => <String, dynamic>{
      'name': instance.name,
      'iso_2': instance.iso2,
      'iso_3': instance.iso3,
      'code': instance.code,
      'locale': instance.locale,
      'currency_code': instance.currencyCode,
      'ID': instance.id,
    };
