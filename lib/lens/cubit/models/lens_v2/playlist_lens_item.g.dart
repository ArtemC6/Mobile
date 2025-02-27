// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'playlist_lens_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistLensItem _$PlaylistLensItemFromJson(Map<String, dynamic> json) =>
    PlaylistLensItem(
      id: json['ID'] as String?,
      createdat: json['createdat'] == null
          ? null
          : DateTime.parse(json['createdat'] as String),
      updatedat: json['updatedat'] == null
          ? null
          : DateTime.parse(json['updatedat'] as String),
      createdby: json['createdby'] as String?,
      updatedby: json['updatedby'] as String?,
      organizationId: json['OrganizationID'],
      showForAll: json['ShowForAll'] as bool?,
      channelId: json['ChannelID'] as String?,
      name: json['Name'] as String?,
      privacy: json['Privacy'] as String?,
      itemCount: (json['ItemCount'] as num?)?.toInt(),
      userName: json['UserName'] as String?,
      channelName: json['ChannelName'] as String?,
      audioSampleRefIdFirst: json['AudioSampleRefIDFirst'] as String?,
      pictureIdFirst: json['PictureIDFirst'] as String?,
      languageIDs: (json['LanguageIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      countRating: json['CountRating'],
      rating: json['Rating'],
      sourceLanguageId: json['SourceLanguageID'] as String?,
    );

Map<String, dynamic> _$PlaylistLensItemToJson(PlaylistLensItem instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'createdat': instance.createdat?.toIso8601String(),
      'updatedat': instance.updatedat?.toIso8601String(),
      'createdby': instance.createdby,
      'updatedby': instance.updatedby,
      'OrganizationID': instance.organizationId,
      'ShowForAll': instance.showForAll,
      'ChannelID': instance.channelId,
      'Name': instance.name,
      'Privacy': instance.privacy,
      'ItemCount': instance.itemCount,
      'UserName': instance.userName,
      'ChannelName': instance.channelName,
      'AudioSampleRefIDFirst': instance.audioSampleRefIdFirst,
      'PictureIDFirst': instance.pictureIdFirst,
      'LanguageIDs': instance.languageIDs,
      'CountRating': instance.countRating,
      'Rating': instance.rating,
      'SourceLanguageID': instance.sourceLanguageId,
    };
