// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vote _$VoteFromJson(Map<String, dynamic> json) => Vote(
      actId: json['ActID'] as String?,
      actIdMinus: json['ActIDMinus'] as String?,
      actIdPlus: json['ActIDPlus'] as String?,
      voteMinus: (json['VoteMinus'] as num?)?.toInt(),
      votePlus: (json['VotePlus'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VoteToJson(Vote instance) => <String, dynamic>{
      'ActID': instance.actId,
      'ActIDMinus': instance.actIdMinus,
      'ActIDPlus': instance.actIdPlus,
      'VoteMinus': instance.voteMinus,
      'VotePlus': instance.votePlus,
    };
