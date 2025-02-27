import 'package:json_annotation/json_annotation.dart';

part 'challenge_lens_item.g.dart';

@JsonSerializable()
class ChallengeLensItem {
  ChallengeLensItem({
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
  });
  factory ChallengeLensItem.fromJson(Map<String, dynamic> json) {
    return _$ChallengeLensItemFromJson(json);
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

  @JsonKey(name: 'SourceLanguageID')
  String? sourceLanguageId;
  @JsonKey(name: 'LanguageID')
  String? languageId;
  @JsonKey(name: 'Difficulty')
  int? difficulty;
  @JsonKey(name: 'Views')
  int? views;
  @JsonKey(name: 'ChannelID')
  String? channelId;
  @JsonKey(name: 'Mode')
  String? mode;
  @JsonKey(name: 'Spelling')
  String? spelling;
  @JsonKey(name: 'Level')
  int? level;
  @JsonKey(name: 'ChannelName')
  String? channelName;
  @JsonKey(name: 'ChannelCreatedBy')
  String? channelCreatedBy;
  @JsonKey(name: 'Asset')
  final dynamic asset;
  @JsonKey(name: 'Categories')
  dynamic categories;
  @JsonKey(name: 'UserName')
  String? userName;

  Map<String, dynamic> toJson() => _$ChallengeLensItemToJson(this);

  ChallengeLensItem copyWith({
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
    String? sourceLanguageId,
    String? languageId,
    int? difficulty,
    int? views,
    String? channelId,
    String? mode,
    String? spelling,
    int? level,
    String? channelName,
    String? channelCreatedBy,
    dynamic asset,
    dynamic categories,
    String? userName,
  }) {
    return ChallengeLensItem(
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
    );
  }
}
