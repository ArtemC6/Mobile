import 'package:json_annotation/json_annotation.dart';

part 'story_lens_item.g.dart';

@JsonSerializable()
class StoryLensItem {
  StoryLensItem({
    this.id,
    this.createdat,
    this.updatedat,
    this.createdby,
    this.updatedby,
    this.organizationId,
    this.showForAll,
    this.channelId,
    this.channelName,
    this.channelCreatedBy,
    this.name,
    this.description,
    this.privacy,
    this.level,
    this.levels,
    this.acts,
    this.actItems,
    this.countRating,
    this.rating,
    this.sourceLanguageId,
    this.onboarding,
    this.istemplate,
    this.userName,
  });
  factory StoryLensItem.fromJson(Map<String, dynamic> json) {
    return _$StoryLensItemFromJson(json);
  }
  @JsonKey(name: 'ID')
  String? id;
  DateTime? createdat;
  DateTime? updatedat;
  String? createdby;
  String? updatedby;
  @JsonKey(name: 'OrganizationID')
  dynamic organizationId;
  @JsonKey(name: 'ShowForAll')
  bool? showForAll;
  @JsonKey(name: 'ChannelID')
  String? channelId;
  @JsonKey(name: 'ChannelName')
  String? channelName;
  @JsonKey(name: 'ChannelCreatedBy')
  String? channelCreatedBy;
  @JsonKey(name: 'Name')
  String? name;
  @JsonKey(name: 'Description')
  dynamic description;
  @JsonKey(name: 'Privacy')
  String? privacy;
  @JsonKey(name: 'Level')
  int? level;
  @JsonKey(name: 'Levels')
  int? levels;
  @JsonKey(name: 'Acts')
  int? acts;
  @JsonKey(name: 'ActItems')
  int? actItems;
  @JsonKey(name: 'CountRating')
  dynamic countRating;
  @JsonKey(name: 'Rating')
  dynamic rating;
  @JsonKey(name: 'SourceLanguageID')
  String? sourceLanguageId;
  @JsonKey(name: 'Onboarding')
  bool? onboarding;
  @JsonKey(name: 'Istemplate')
  bool? istemplate;
  @JsonKey(name: 'UserName')
  String? userName;

  Map<String, dynamic> toJson() => _$StoryLensItemToJson(this);

  StoryLensItem copyWith({
    String? id,
    DateTime? createdat,
    DateTime? updatedat,
    String? createdby,
    String? updatedby,
    dynamic organizationId,
    bool? showForAll,
    String? channelId,
    String? channelName,
    String? channelCreatedBy,
    String? name,
    dynamic description,
    String? privacy,
    int? level,
    int? levels,
    int? acts,
    int? actItems,
    dynamic countRating,
    dynamic rating,
    String? sourceLanguageId,
    bool? onboarding,
    bool? istemplate,
    String? userName,
  }) {
    return StoryLensItem(
      id: id ?? this.id,
      createdat: createdat ?? this.createdat,
      updatedat: updatedat ?? this.updatedat,
      createdby: createdby ?? this.createdby,
      updatedby: updatedby ?? this.updatedby,
      organizationId: organizationId ?? this.organizationId,
      showForAll: showForAll ?? this.showForAll,
      channelId: channelId ?? this.channelId,
      channelName: channelName ?? this.channelName,
      channelCreatedBy: channelCreatedBy ?? this.channelCreatedBy,
      name: name ?? this.name,
      description: description ?? this.description,
      privacy: privacy ?? this.privacy,
      level: level ?? this.level,
      levels: levels ?? this.levels,
      acts: acts ?? this.acts,
      actItems: actItems ?? this.actItems,
      countRating: countRating ?? this.countRating,
      rating: rating ?? this.rating,
      sourceLanguageId: sourceLanguageId ?? this.sourceLanguageId,
      onboarding: onboarding ?? this.onboarding,
      istemplate: istemplate ?? this.istemplate,
      userName: userName ?? this.userName,
    );
  }
}
