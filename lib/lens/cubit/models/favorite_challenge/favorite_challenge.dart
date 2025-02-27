import 'package:json_annotation/json_annotation.dart';

import 'package:voccent/lens/cubit/models/favorite_challenge/access.dart';
import 'package:voccent/lens/cubit/models/favorite_challenge/asset.dart';

part 'favorite_challenge.g.dart';

@JsonSerializable()
class FavoriteChallenge {
  FavoriteChallenge({
    this.id,
    this.createdat,
    this.updatedat,
    this.createdby,
    this.name,
    this.audioSampleRefId,
    this.privacy,
    this.organizationId,
    this.showForAll,
    this.countRating,
    this.rating,
    this.sourceLanguageId,
    this.languageId,
    this.difficulty,
    this.views,
    this.channelId,
    this.mode,
    this.spelling,
    this.level,
    this.channelName,
    this.channelCreatedBy,
    this.asset,
    this.categories,
    this.userName,
    this.access,
  });

  factory FavoriteChallenge.fromJson(Map<String, dynamic> json) {
    return _$FavoriteChallengeFromJson(json);
  }
  @JsonKey(name: 'ID')
  String? id;
  DateTime? createdat;
  DateTime? updatedat;
  String? createdby;
  @JsonKey(name: 'Name')
  String? name;
  @JsonKey(name: 'AudioSampleRefID')
  String? audioSampleRefId;
  @JsonKey(name: 'Privacy')
  String? privacy;
  @JsonKey(name: 'OrganizationID')
  dynamic organizationId;
  @JsonKey(name: 'ShowForAll')
  bool? showForAll;
  @JsonKey(name: 'CountRating')
  int? countRating;
  @JsonKey(name: 'Rating')
  num? rating;
  @JsonKey(name: 'SourceLanguageID')
  String? sourceLanguageId;
  @JsonKey(name: 'LanguageID')
  String? languageId;
  @JsonKey(name: 'Difficulty')
  dynamic difficulty;
  @JsonKey(name: 'Views')
  int? views;
  @JsonKey(name: 'ChannelID')
  String? channelId;
  @JsonKey(name: 'Mode')
  String? mode;
  @JsonKey(name: 'Spelling')
  String? spelling;
  @JsonKey(name: 'Level')
  dynamic level;
  @JsonKey(name: 'ChannelName')
  String? channelName;
  @JsonKey(name: 'ChannelCreatedBy')
  String? channelCreatedBy;
  @JsonKey(name: 'Asset')
  Asset? asset;
  @JsonKey(name: 'Categories')
  dynamic categories;
  @JsonKey(name: 'UserName')
  String? userName;
  @JsonKey(name: 'Access')
  Access? access;

  Map<String, dynamic> toJson() => _$FavoriteChallengeToJson(this);

  FavoriteChallenge copyWith({
    String? id,
    DateTime? createdat,
    DateTime? updatedat,
    String? createdby,
    String? name,
    String? audioSampleRefId,
    String? privacy,
    dynamic organizationId,
    bool? showForAll,
    int? countRating,
    num? rating,
    String? sourceLanguageId,
    String? languageId,
    dynamic difficulty,
    int? views,
    String? channelId,
    String? mode,
    String? spelling,
    dynamic level,
    String? channelName,
    String? channelCreatedBy,
    Asset? asset,
    dynamic categories,
    String? userName,
    Access? access,
  }) {
    return FavoriteChallenge(
      id: id ?? this.id,
      createdat: createdat ?? this.createdat,
      updatedat: updatedat ?? this.updatedat,
      createdby: createdby ?? this.createdby,
      name: name ?? this.name,
      audioSampleRefId: audioSampleRefId ?? this.audioSampleRefId,
      privacy: privacy ?? this.privacy,
      organizationId: organizationId ?? this.organizationId,
      showForAll: showForAll ?? this.showForAll,
      countRating: countRating ?? this.countRating,
      rating: rating ?? this.rating,
      sourceLanguageId: sourceLanguageId ?? this.sourceLanguageId,
      languageId: languageId ?? this.languageId,
      difficulty: difficulty ?? this.difficulty,
      views: views ?? this.views,
      channelId: channelId ?? this.channelId,
      mode: mode ?? this.mode,
      spelling: spelling ?? this.spelling,
      level: level ?? this.level,
      channelName: channelName ?? this.channelName,
      channelCreatedBy: channelCreatedBy ?? this.channelCreatedBy,
      asset: asset ?? this.asset,
      categories: categories ?? this.categories,
      userName: userName ?? this.userName,
      access: access ?? this.access,
    );
  }
}
