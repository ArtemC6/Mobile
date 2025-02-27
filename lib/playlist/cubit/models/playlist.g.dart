// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Playlist _$PlaylistFromJson(Map<String, dynamic> json) => Playlist(
      id: json['ID'] as String? ?? '',
      createdAt: json['createdt'] as String?,
      channelId: json['ChannelID'] as String?,
      createdBy: json['createdby'] as String?,
      items: (json['Items'] as List<dynamic>?)
          ?.map((e) => PlaylistItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['Name'] as String?,
      pictureIdFirst: json['PictureIDFirst'] as String?,
    );

Map<String, dynamic> _$PlaylistToJson(Playlist instance) => <String, dynamic>{
      'ID': instance.id,
      'createdt': instance.createdAt,
      'createdby': instance.createdBy,
      'ChannelID': instance.channelId,
      'Name': instance.name,
      'Items': instance.items,
      'PictureIDFirst': instance.pictureIdFirst,
    };
