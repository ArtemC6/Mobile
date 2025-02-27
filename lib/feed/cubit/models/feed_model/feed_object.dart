import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:voccent/feed/cubit/models/feed_model/asset.dart';
import 'package:voccent/feed/cubit/models/feed_model/story_current_pass.dart';

part 'feed_object.g.dart';

@JsonSerializable()
class FeedObject extends Equatable {
  const FeedObject({
    this.id,
    this.createdat,
    this.updatedat,
    this.createdby,
    this.name,
    this.audioSampleRefId,
    this.privacy,
    this.tags,
    this.countRating,
    this.rating,
    this.languageId,
    this.difficulty,
    this.views,
    this.channelId,
    this.asset,
    this.mode,
    this.categories,
    this.spelling,
    this.level,
    this.userName,
    this.channelName,
    this.channelCreatedBy,
    this.parentPrivacy,
    this.description,
    this.languageIds,
    this.pictureIdFirst,
    this.itemCount,
    this.levels,
    this.actItems,
    this.currentPass,
  });

  factory FeedObject.fromJson(Map<String, dynamic> json) {
    return _$FeedObjectFromJson(json);
  }
  @JsonKey(name: 'ID')
  final String? id;
  final DateTime? createdat;
  final DateTime? updatedat;
  final String? createdby;
  @JsonKey(name: 'Name')
  final String? name;
  @JsonKey(name: 'AudioSampleRefID')
  final String? audioSampleRefId;
  @JsonKey(name: 'Privacy')
  final String? privacy;
  @JsonKey(name: 'Tags')
  final dynamic tags;
  @JsonKey(name: 'CountRating')
  final double? countRating;
  @JsonKey(name: 'Rating')
  final double? rating;
  @JsonKey(name: 'LanguageID')
  final String? languageId;
  @JsonKey(name: 'Difficulty')
  final int? difficulty;
  @JsonKey(name: 'Views')
  final dynamic views;
  @JsonKey(name: 'ChannelID')
  final String? channelId;
  @JsonKey(name: 'Asset')
  final Asset? asset;
  @JsonKey(name: 'Mode')
  final String? mode;
  @JsonKey(name: 'Categories')
  final dynamic categories;
  @JsonKey(name: 'Spelling')
  final dynamic spelling;
  @JsonKey(name: 'Level')
  final int? level;
  @JsonKey(name: 'UserName')
  final String? userName;
  @JsonKey(name: 'ChannelName')
  final String? channelName;
  @JsonKey(name: 'ChannelCreatedBy')
  final String? channelCreatedBy;
  @JsonKey(name: 'ParentPrivacy')
  final String? parentPrivacy;
  @JsonKey(name: 'Description')
  final String? description;
  @JsonKey(name: 'LanguageIDs')
  final List<String>? languageIds;
  @JsonKey(name: 'PictureIDFirst')
  final String? pictureIdFirst;
  @JsonKey(name: 'ItemCount')
  final int? itemCount;
  @JsonKey(name: 'Levels')
  final int? levels;
  @JsonKey(name: 'ActItems')
  final int? actItems;
  @JsonKey(name: 'CurrentPass')
  final StoryCurrentPass? currentPass;

  Map<String, dynamic> toJson() => _$FeedObjectToJson(this);

  @override
  List<Object?> get props {
    return [
      id,
      createdat,
      updatedat,
      createdby,
      name,
      audioSampleRefId,
      privacy,
      tags,
      countRating,
      rating,
      languageId,
      difficulty,
      views,
      channelId,
      asset,
      mode,
      categories,
      spelling,
      level,
      userName,
      channelName,
      channelCreatedBy,
      parentPrivacy,
      description,
      languageIds,
      pictureIdFirst,
      itemCount,
      levels,
      actItems,
      currentPass,
    ];
  }
}
