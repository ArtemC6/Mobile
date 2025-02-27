import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:voccent/challenge/cubit/models/challenge_attempt/emotion_data.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/fingerprint.dart';
import 'package:voccent/story/cubit/models/comparison.dart';
import 'package:voccent/story/cubit/models/condition.dart';
import 'package:voccent/story/cubit/models/item_pass_quiz.dart';
import 'package:voccent/story/cubit/models/item_quiz_list.dart';

part 'story_current_pass.g.dart';

enum ItemType {
  audioComparison,
  singleChoiceVariants,
  multipleChoiceVariants,
  singleTextInput,
  multipleTextInputs,
  actTitle,
  message,
  foreignLink,
  emotionAnalysis,
  semanticAnalysis,
}

@JsonSerializable()
class StoryCurrentPass extends Equatable {
  const StoryCurrentPass({
    this.actAudiosampleRefId,
    this.actBackgroundAudiosampleRefId,
    this.actConditions,
    this.actDescription,
    this.actId,
    this.actName,
    this.itemAudiosamplerefid,
    this.itemVideosamplerefid,
    this.itemCharacterID,
    this.itemCharacterName,
    this.itemId,
    this.itemLanguageId,
    this.itemUserAudiosamplerefid,
    this.itemPassAudiosamplerefid,
    this.itemPassID,
    this.itemSpelling,
    this.userId,
    this.userName,
    this.itemType,
    this.comparePercent,
    this.itemPassQuiz,
    this.itemQuizCount,
    this.itemQuizList,
    this.itemQuizMultiple,
    this.itemQuizType,
    this.itemPassPause,
    this.itemMessage,
    this.fingerprint,
    this.emotionData,
    this.comparison,
    this.originalPhrase,
    this.translatedPhrase,
    this.autoShow,
    this.itemRecordDuration,
    this.itemVideoStart,
    this.itemVideoEnd,
    this.itemVideoLoop,
    this.itemVideoControls,
    this.itemVisualType,
  });

  factory StoryCurrentPass.fromJson(Map<String, dynamic> json) =>
      _$StoryCurrentPassFromJson(json);
  Map<String, dynamic> toJson() => _$StoryCurrentPassToJson(this);

  Future<void> close() => Future<void>.value();

  ItemType get type {
    if (itemType == 0) {
      return ItemType.audioComparison;
    }

    if (itemType == 1 && itemQuizType == 0 && (itemQuizMultiple ?? false)) {
      return ItemType.multipleChoiceVariants;
    }

    if (itemType == 1 && itemQuizType == 0 && itemQuizMultiple == false) {
      return ItemType.singleChoiceVariants;
    }

    if (itemType == 2) {
      return ItemType.message;
    }

    if (itemType == 3 && itemQuizType == 0 && itemQuizMultiple == false) {
      return ItemType.foreignLink;
    }

    if (itemType == 1 && itemQuizType == 1 && (itemQuizMultiple ?? true)) {
      return ItemType.multipleTextInputs;
    }

    if (itemType == 1 && itemQuizType == 1 && itemQuizMultiple == false) {
      return ItemType.singleTextInput;
    }

    if (itemType == 4) {
      return ItemType.emotionAnalysis;
    }

    if (itemType == 5) {
      return ItemType.semanticAnalysis;
    }

    if (actId != null && itemId == null) {
      return ItemType.actTitle;
    }

    throw UnimplementedError('3cc2daf0: unsupported Story type');
  }

  bool get isAudioComparisonOrEmotionAnalysis =>
      type == ItemType.audioComparison || type == ItemType.emotionAnalysis;

  @JsonKey(name: 'ActAudiosamplerefid')
  final String? actAudiosampleRefId;
  @JsonKey(name: 'ActBackgroundAudiosamplerefid')
  final String? actBackgroundAudiosampleRefId;
  @JsonKey(name: 'ActConditions')
  final List<Condition>? actConditions;
  @JsonKey(name: 'ActDescription')
  final String? actDescription;
  @JsonKey(name: 'ActID')
  final String? actId;
  @JsonKey(name: 'ActName')
  final String? actName;
  @JsonKey(name: 'ComparePercent')
  final double? comparePercent;
  @JsonKey(name: 'ItemAudiosamplerefid')
  final String? itemAudiosamplerefid;
  @JsonKey(name: 'ItemVideosamplerefid')
  final String? itemVideosamplerefid;
  @JsonKey(name: 'ItemCharacterID')
  final String? itemCharacterID;
  @JsonKey(name: 'ItemCharacterName')
  final String? itemCharacterName;
  @JsonKey(name: 'ItemID')
  final String? itemId;
  @JsonKey(name: 'ItemLanguageID')
  final String? itemLanguageId;
  @JsonKey(name: 'ItemUserAudiosamplerefid')
  final String? itemUserAudiosamplerefid;
  @JsonKey(name: 'ItemPassAudiosamplerefid')
  final String? itemPassAudiosamplerefid;
  @JsonKey(name: 'ItemPassID')
  final String? itemPassID;
  @JsonKey(name: 'ItemPassQuiz')
  final ItemPassQuiz? itemPassQuiz;
  @JsonKey(name: 'ItemQuizCount')
  final int? itemQuizCount;
  @JsonKey(name: 'ItemPassPause')
  final int? itemPassPause;
  @JsonKey(name: 'ItemQuizList')
  final List<ItemQuizList>? itemQuizList;
  @JsonKey(name: 'ItemQuizMultiple')
  final bool? itemQuizMultiple;
  @JsonKey(name: 'ItemQuizType')
  final int? itemQuizType;
  @JsonKey(name: 'ItemSpelling')
  final String? itemSpelling;
  @JsonKey(name: 'UserID')
  final String? userId;
  @JsonKey(name: 'UserName')
  final String? userName;
  @JsonKey(name: 'ItemType')
  final int? itemType;
  @JsonKey(name: 'ItemMessage')
  final String? itemMessage;
  @JsonKey(name: 'AutoShow')
  final bool? autoShow;
  @JsonKey(name: 'ItemRecordDuration')
  final int? itemRecordDuration;
  @JsonKey(name: 'ItemVideoStart')
  final int? itemVideoStart;
  @JsonKey(name: 'ItemVideoEnd')
  final int? itemVideoEnd;
  @JsonKey(name: 'ItemVideoLoop')
  final bool? itemVideoLoop;
  @JsonKey(name: 'ItemVideoControls')
  final bool? itemVideoControls;
  @JsonKey(name: 'ItemVisualType')
  final int? itemVisualType;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final Fingerprint? fingerprint;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final EmotionData? emotionData;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Comparison? comparison;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? originalPhrase;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? translatedPhrase;

  StoryCurrentPass copyWith({
    String? actAudiosampleRefId,
    String? actBackgroundAudiosampleRefId,
    List<Condition>? actConditions,
    String? actDescription,
    String? actId,
    String? actName,
    String? itemAudiosamplerefid,
    String? itemVideosamplerefid,
    String? itemCharacterID,
    String? itemCharacterName,
    String? itemId,
    String? itemLanguageId,
    String? itemUserAudiosamplerefid,
    String? itemPassAudiosamplerefid,
    String? itemPassID,
    String? itemSpelling,
    String? userId,
    String? userName,
    int? itemType,
    double? comparePercent,
    ItemPassQuiz? itemPassQuiz,
    int? itemQuizCount,
    List<ItemQuizList>? itemQuizList,
    bool? itemQuizMultiple,
    int? itemQuizType,
    int? itemPassPause,
    String? itemMessage,
    Fingerprint? fingerprint,
    EmotionData? emotionData,
    Comparison? comparison,
    String? originalPhrase,
    String? translatedPhrase,
    bool? autoShow,
    int? itemRecordDuration,
    int? itemVideoStart,
    int? itemVideoEnd,
    bool? itemVideoLoop,
    bool? itemVideoControls,
    int? itemVisualType,
  }) {
    return StoryCurrentPass(
      actAudiosampleRefId: actAudiosampleRefId ?? this.actAudiosampleRefId,
      actBackgroundAudiosampleRefId:
          actBackgroundAudiosampleRefId ?? this.actBackgroundAudiosampleRefId,
      actConditions: actConditions ?? this.actConditions,
      actDescription: actDescription ?? this.actDescription,
      actId: actId ?? this.actId,
      actName: actName ?? this.actName,
      itemAudiosamplerefid: itemAudiosamplerefid ?? this.itemAudiosamplerefid,
      itemVideosamplerefid: itemVideosamplerefid ?? this.itemVideosamplerefid,
      itemCharacterID: itemCharacterID ?? this.itemCharacterID,
      itemCharacterName: itemCharacterName ?? this.itemCharacterName,
      itemId: itemId ?? this.itemId,
      itemLanguageId: itemLanguageId ?? this.itemLanguageId,
      itemUserAudiosamplerefid:
          itemUserAudiosamplerefid ?? this.itemUserAudiosamplerefid,
      itemPassAudiosamplerefid:
          itemPassAudiosamplerefid ?? this.itemPassAudiosamplerefid,
      itemPassID: itemPassID ?? this.itemPassID,
      itemSpelling: itemSpelling ?? this.itemSpelling,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      itemType: itemType ?? this.itemType,
      comparePercent: comparePercent ?? this.comparePercent,
      itemPassQuiz: itemPassQuiz ?? this.itemPassQuiz,
      itemQuizCount: itemQuizCount ?? this.itemQuizCount,
      itemQuizList: itemQuizList ?? this.itemQuizList,
      itemQuizMultiple: itemQuizMultiple ?? this.itemQuizMultiple,
      itemQuizType: itemQuizType ?? this.itemQuizType,
      itemPassPause: itemPassPause ?? this.itemPassPause,
      itemMessage: itemMessage ?? this.itemMessage,
      fingerprint: fingerprint ?? this.fingerprint,
      emotionData: emotionData ?? this.emotionData,
      comparison: comparison ?? this.comparison,
      originalPhrase: originalPhrase ?? this.originalPhrase,
      translatedPhrase: translatedPhrase ?? this.translatedPhrase,
      autoShow: autoShow ?? this.autoShow,
      itemRecordDuration: itemRecordDuration ?? this.itemRecordDuration,
      itemVideoStart: itemVideoStart ?? this.itemVideoStart,
      itemVideoEnd: itemVideoEnd ?? this.itemVideoEnd,
      itemVideoLoop: itemVideoLoop ?? this.itemVideoLoop,
      itemVideoControls: itemVideoControls ?? this.itemVideoControls,
      itemVisualType: itemVisualType ?? this.itemVisualType,
    );
  }

  @override
  List<Object?> get props => [
        actAudiosampleRefId,
        actBackgroundAudiosampleRefId,
        actConditions,
        actDescription,
        actId,
        actName,
        itemAudiosamplerefid,
        itemVideosamplerefid,
        itemCharacterID,
        itemCharacterName,
        itemId,
        itemLanguageId,
        itemUserAudiosamplerefid,
        itemPassAudiosamplerefid,
        itemPassID,
        itemSpelling,
        userId,
        userName,
        itemType,
        comparePercent,
        itemPassQuiz,
        itemQuizCount,
        itemQuizList,
        itemQuizMultiple,
        itemQuizType,
        itemPassPause,
        itemMessage,
        fingerprint,
        emotionData,
        comparison,
        originalPhrase,
        translatedPhrase,
        autoShow,
        itemRecordDuration,
        itemVideoStart,
        itemVideoEnd,
        itemVideoLoop,
        itemVideoControls,
        itemVisualType,
      ];
}
