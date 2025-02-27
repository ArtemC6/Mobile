// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'challenge_favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeFavorite _$ChallengeFavoriteFromJson(Map<String, dynamic> json) =>
    ChallengeFavorite(
      userId: json['UserID'] as String,
      objectId: json['ObjectID'] as String,
      isFavorite: json['IsFavorite'] as bool,
    );

Map<String, dynamic> _$ChallengeFavoriteToJson(ChallengeFavorite instance) =>
    <String, dynamic>{
      'UserID': instance.userId,
      'ObjectID': instance.objectId,
      'IsFavorite': instance.isFavorite,
    };
