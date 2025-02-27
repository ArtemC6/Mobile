// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      credId: json['cred_id'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      firebaseidentities: (json['firebaseidentities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      birthdayDateTime: json['BirthdayDateTime'] as String?,
      currentLangs: json['currentLangs'] as String?,
      nextLangs: json['nextLangs'] as String?,
      voice: json['voice'] as String?,
      username: json['username'] as String?,
      socialId: json['SocialID'] as String?,
      mailMain: json['MailMain'] as bool?,
      mailChannel: json['MailChannel'] as bool?,
      mailChat: json['MailChat'] as bool?,
      asset: json['Asset'] == null
          ? null
          : Asset.fromJson(json['Asset'] as Map<String, dynamic>),
      xpTotal: (json['XPTotal'] as num?)?.toInt(),
      xpFactorCurrent: (json['XPFactorCurrent'] as num?)?.toInt(),
      organizationId: json['OrganizationID'] as String?,
      lastClassroomId: json['last_classroom_id'],
      currentlang: (json['currentlang'] as List<dynamic>?)
          ?.map((e) => UserLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      worklang: (json['worklang'] as List<dynamic>?)
          ?.map((e) => UserLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['ID'] as String?,
      focusOrganizationID: json['FocusOrganizationID'] as String?,
      focusOrganizationName: json['FocusOrganizationName'] as String?,
      focusOrganizationDate: json['FocusOrganizationDate'] as String?,
      date: json['date'],
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'cred_id': instance.credId,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'firebaseidentities': instance.firebaseidentities,
      'BirthdayDateTime': instance.birthdayDateTime,
      'currentLangs': instance.currentLangs,
      'nextLangs': instance.nextLangs,
      'voice': instance.voice,
      'username': instance.username,
      'SocialID': instance.socialId,
      'MailMain': instance.mailMain,
      'MailChannel': instance.mailChannel,
      'MailChat': instance.mailChat,
      'Asset': instance.asset,
      'XPTotal': instance.xpTotal,
      'XPFactorCurrent': instance.xpFactorCurrent,
      'OrganizationID': instance.organizationId,
      'last_classroom_id': instance.lastClassroomId,
      'currentlang': instance.currentlang,
      'worklang': instance.worklang,
      'ID': instance.id,
      'FocusOrganizationID': instance.focusOrganizationID,
      'FocusOrganizationName': instance.focusOrganizationName,
      'FocusOrganizationDate': instance.focusOrganizationDate,
      'date': instance.date,
    };
