import 'package:json_annotation/json_annotation.dart';

part 'playlist_lens_item.g.dart';

@JsonSerializable()
class PlaylistLensItem {
  PlaylistLensItem({
    this.id,
    this.createdat,
    this.updatedat,
    this.createdby,
    this.updatedby,
    this.organizationId,
    this.showForAll,
    this.channelId,
    this.name,
    this.privacy,
    this.itemCount,
    this.userName,
    this.channelName,
    this.audioSampleRefIdFirst,
    this.pictureIdFirst,
    this.languageIDs,
    this.countRating,
    this.rating,
    this.sourceLanguageId,
  });
  factory PlaylistLensItem.fromJson(Map<String, dynamic> json) {
    return _$PlaylistLensItemFromJson(json);
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
  @JsonKey(name: 'Name')
  String? name;
  @JsonKey(name: 'Privacy')
  String? privacy;
  @JsonKey(name: 'ItemCount')
  int? itemCount;
  @JsonKey(name: 'UserName')
  String? userName;
  @JsonKey(name: 'ChannelName')
  String? channelName;
  @JsonKey(name: 'AudioSampleRefIDFirst')
  String? audioSampleRefIdFirst;
  @JsonKey(name: 'PictureIDFirst')
  String? pictureIdFirst;
  @JsonKey(name: 'LanguageIDs')
  List<String>? languageIDs;
  @JsonKey(name: 'CountRating')
  dynamic countRating;
  @JsonKey(name: 'Rating')
  dynamic rating;
  @JsonKey(name: 'SourceLanguageID')
  String? sourceLanguageId;

  Map<String, dynamic> toJson() => _$PlaylistLensItemToJson(this);

  PlaylistLensItem copyWith({
    String? id,
    DateTime? createdat,
    DateTime? updatedat,
    String? createdby,
    String? updatedby,
    dynamic organizationId,
    bool? showForAll,
    String? channelId,
    String? name,
    String? privacy,
    int? itemCount,
    String? userName,
    String? channelName,
    String? audioSampleRefIdFirst,
    String? pictureIdFirst,
    List<String>? languageIDs,
    dynamic countRating,
    dynamic rating,
    String? sourceLanguageId,
  }) {
    return PlaylistLensItem(
      id: id ?? this.id,
      createdat: createdat ?? this.createdat,
      updatedat: updatedat ?? this.updatedat,
      createdby: createdby ?? this.createdby,
      updatedby: updatedby ?? this.updatedby,
      organizationId: organizationId ?? this.organizationId,
      showForAll: showForAll ?? this.showForAll,
      channelId: channelId ?? this.channelId,
      name: name ?? this.name,
      privacy: privacy ?? this.privacy,
      itemCount: itemCount ?? this.itemCount,
      userName: userName ?? this.userName,
      channelName: channelName ?? this.channelName,
      audioSampleRefIdFirst:
          audioSampleRefIdFirst ?? this.audioSampleRefIdFirst,
      pictureIdFirst: pictureIdFirst ?? this.pictureIdFirst,
      languageIDs: languageIDs ?? this.languageIDs,
      countRating: countRating ?? this.countRating,
      rating: rating ?? this.rating,
      sourceLanguageId: sourceLanguageId ?? this.sourceLanguageId,
    );
  }
}
