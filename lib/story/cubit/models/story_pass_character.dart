// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story_pass_character.g.dart';

@JsonSerializable()
class StoryPassCharacter extends Equatable {
  const StoryPassCharacter({
    required this.id,
    required this.storyId,
    this.characterId,
    this.characterName,
    this.userId,
    this.userName,
    this.userEmail,
    this.userCheck = false,
    this.compareEmotionPercent,
    this.compareBreathPercent,
    this.compareEnergyPercent,
    this.comparePercent,
    this.comparePitchPercent,
    this.comparePronunciationPercent,
    this.percent,
  });

  factory StoryPassCharacter.fromJson(Map<String, dynamic> json) =>
      _$StoryPassCharacterFromJson(json);
  Map<String, dynamic> toJson() => _$StoryPassCharacterToJson(this);

  @JsonKey(name: 'ID')
  final String id;
  @JsonKey(name: 'StoryID')
  final String storyId;
  @JsonKey(name: 'CharacterID')
  final String? characterId;
  @JsonKey(name: 'CharacterName')
  final String? characterName;
  @JsonKey(name: 'UserID')
  final String? userId;
  @JsonKey(name: 'UserName')
  final String? userName;
  @JsonKey(name: 'UserEmail')
  final String? userEmail;
  @JsonKey(name: 'UserCheck')
  final bool userCheck;
  @JsonKey(name: 'CompareEmotionPercent')
  final double? compareEmotionPercent;
  @JsonKey(name: 'CompareBreathPercent')
  final double? compareBreathPercent;
  @JsonKey(name: 'CompareEnergyPercent')
  final double? compareEnergyPercent;
  @JsonKey(name: 'ComparePercent')
  final double? comparePercent;
  @JsonKey(name: 'Percent')
  final double? percent;
  @JsonKey(name: 'ComparePitchPercent')
  final double? comparePitchPercent;
  @JsonKey(name: 'ComparePronunciationPercent')
  final double? comparePronunciationPercent;

  String? get comparePercentString {
    if (comparePercent == null) {
      return null;
    }

    return NumberFormat("##'%").format(comparePercent);
  }

  StoryPassCharacter copyWith({
    String? id,
    String? storyId,
    String? characterId,
    String? characterName,
    String? userId,
    String? userName,
    String? userEmail,
    bool? userCheck,
    bool? isOnline,
  }) {
    return StoryPassCharacter(
      id: id ?? this.id,
      storyId: storyId ?? this.storyId,
      characterId: characterId ?? this.characterId,
      characterName: characterName ?? this.characterName,
      userId: userCheck == false ? null : userId ?? this.userId,
      userName: userCheck == false ? null : userName ?? this.userName,
      userEmail: userCheck == false ? null : userEmail ?? this.userEmail,
      userCheck: userCheck ?? this.userCheck,
    );
  }

  @override
  List<Object?> get props => [
        id,
        storyId,
        characterId,
        characterName,
        userId,
        userName,
        userEmail,
        userCheck,
        compareEmotionPercent,
        compareBreathPercent,
        compareEnergyPercent,
        comparePercent,
        comparePitchPercent,
        comparePronunciationPercent,
      ];
}
