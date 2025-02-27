import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:voccent/home/cubit/models/user/asset.dart';
import 'package:voccent/home/cubit/models/user/user_language.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  const User({
    this.credId,
    this.firstname,
    this.lastname,
    this.firebaseidentities,
    this.birthdayDateTime,
    this.currentLangs,
    this.nextLangs,
    this.voice,
    this.username,
    this.socialId,
    this.mailMain,
    this.mailChannel,
    this.mailChat,
    this.asset,
    this.xpTotal,
    this.xpFactorCurrent,
    this.organizationId,
    this.lastClassroomId,
    this.currentlang,
    this.worklang,
    this.id,
    this.focusOrganizationID,
    this.focusOrganizationName,
    this.focusOrganizationDate,
    this.date,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  User copyWith({
    String? credId,
    String? firstname,
    String? lastname,
    List<String>? firebaseidentities,
    String? birthdayDateTime,
    String? currentLangs,
    String? nextLangs,
    String? voice,
    String? username,
    String? socialId,
    bool? mailMain,
    bool? mailChannel,
    bool? mailChat,
    Asset? asset,
    int? xpTotal,
    int? xpFactorCurrent,
    String? organizationId,
    dynamic lastClassroomId,
    List<UserLanguage>? currentlang,
    List<UserLanguage>? worklang,
    String? id,
    String? focusOrganizationID,
    String? focusOrganizationName,
    String? focusOrganizationDate,
    dynamic date,
  }) {
    return User(
      credId: credId ?? this.credId,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      firebaseidentities: firebaseidentities ?? this.firebaseidentities,
      birthdayDateTime: birthdayDateTime ?? this.birthdayDateTime,
      currentLangs: currentLangs ?? this.currentLangs,
      nextLangs: nextLangs ?? this.nextLangs,
      voice: voice ?? this.voice,
      username: username ?? this.username,
      socialId: socialId ?? this.socialId,
      mailMain: mailMain ?? this.mailMain,
      mailChannel: mailChannel ?? this.mailChannel,
      mailChat: mailChat ?? this.mailChat,
      asset: asset ?? this.asset,
      xpTotal: xpTotal ?? this.xpTotal,
      xpFactorCurrent: xpFactorCurrent ?? this.xpFactorCurrent,
      organizationId: organizationId ?? this.organizationId,
      lastClassroomId: lastClassroomId ?? this.lastClassroomId,
      currentlang: currentlang ?? this.currentlang,
      worklang: worklang ?? this.worklang,
      id: id ?? this.id,
      focusOrganizationID: focusOrganizationID ?? this.focusOrganizationID,
      focusOrganizationName:
          focusOrganizationName ?? this.focusOrganizationName,
      focusOrganizationDate:
          focusOrganizationDate ?? this.focusOrganizationDate,
      date: date ?? this.date,
    );
  }

  @JsonKey(name: 'cred_id')
  final String? credId;
  final String? firstname;
  final String? lastname;
  final List<String>? firebaseidentities;
  @JsonKey(name: 'BirthdayDateTime')
  final String? birthdayDateTime;
  final String? currentLangs;
  final String? nextLangs;
  final String? voice;
  final String? username;
  @JsonKey(name: 'SocialID')
  final String? socialId;
  @JsonKey(name: 'MailMain')
  final bool? mailMain;
  @JsonKey(name: 'MailChannel')
  final bool? mailChannel;
  @JsonKey(name: 'MailChat')
  final bool? mailChat;
  @JsonKey(name: 'Asset')
  final Asset? asset;
  @JsonKey(name: 'XPTotal')
  final int? xpTotal;
  @JsonKey(name: 'XPFactorCurrent')
  final int? xpFactorCurrent;
  @JsonKey(name: 'OrganizationID')
  final String? organizationId;
  @JsonKey(name: 'last_classroom_id')
  final dynamic lastClassroomId;
  final List<UserLanguage>? currentlang;
  final List<UserLanguage>? worklang;
  @JsonKey(name: 'ID')
  final String? id;
  @JsonKey(name: 'FocusOrganizationID')
  final String? focusOrganizationID;
  @JsonKey(name: 'FocusOrganizationName')
  final String? focusOrganizationName;
  @JsonKey(name: 'FocusOrganizationDate')
  final String? focusOrganizationDate;
  final dynamic date;

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [
        credId,
        firstname,
        lastname,
        firebaseidentities,
        birthdayDateTime,
        currentLangs,
        nextLangs,
        voice,
        username,
        socialId,
        mailMain,
        mailChannel,
        mailChat,
        asset,
        xpTotal,
        xpFactorCurrent,
        organizationId,
        lastClassroomId,
        currentlang,
        worklang,
        id,
        focusOrganizationID,
        focusOrganizationName,
        focusOrganizationDate,
        date,
      ];
}
