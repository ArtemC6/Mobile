// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      id: json['ID'] as String,
      name: json['Name'] as String,
      description: json['Description'] as String?,
      channelId: json['ChannelID'] as String?,
      channelName: json['ChannelName'] as String?,
      channelCreatedby: json['ChannelCreatedBy'] as String?,
      createdat: json['createdat'] == null
          ? null
          : DateTime.parse(json['createdat'] as String),
      createdby: json['createdby'] as String?,
    );

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'ID': instance.id,
      'Name': instance.name,
      'Description': instance.description,
      'ChannelID': instance.channelId,
      'ChannelName': instance.channelName,
      'ChannelCreatedBy': instance.channelCreatedby,
      'createdat': instance.createdat?.toIso8601String(),
      'createdby': instance.createdby,
    };
