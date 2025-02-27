// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'confirmation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Confirmation _$ConfirmationFromJson(Map<String, dynamic> json) => Confirmation(
      id: json['ID'] as String?,
      objectId: json['ObjectID'] as String?,
      sharedWith: json['SharedWith'] as String?,
      sharedWithEmail: json['SharedWithEmail'] as String?,
      sharedWithName: json['SharedWithName'] as String?,
      status: json['Status'] as String?,
      type: json['Type'] as String?,
    );

Map<String, dynamic> _$ConfirmationToJson(Confirmation instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'ObjectID': instance.objectId,
      'SharedWith': instance.sharedWith,
      'SharedWithEmail': instance.sharedWithEmail,
      'SharedWithName': instance.sharedWithName,
      'Status': instance.status,
      'Type': instance.type,
    };
