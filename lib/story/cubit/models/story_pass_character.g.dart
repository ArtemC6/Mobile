// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, require_trailing_commas

part of 'story_pass_character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryPassCharacter _$StoryPassCharacterFromJson(Map<String, dynamic> json) =>
    StoryPassCharacter(
      id: json['ID'] as String,
      storyId: json['StoryID'] as String,
      characterId: json['CharacterID'] as String?,
      characterName: json['CharacterName'] as String?,
      userId: json['UserID'] as String?,
      userName: json['UserName'] as String?,
      userEmail: json['UserEmail'] as String?,
      userCheck: json['UserCheck'] as bool? ?? false,
      compareEmotionPercent:
          (json['CompareEmotionPercent'] as num?)?.toDouble(),
      compareBreathPercent: (json['CompareBreathPercent'] as num?)?.toDouble(),
      compareEnergyPercent: (json['CompareEnergyPercent'] as num?)?.toDouble(),
      comparePercent: (json['ComparePercent'] as num?)?.toDouble(),
      comparePitchPercent: (json['ComparePitchPercent'] as num?)?.toDouble(),
      comparePronunciationPercent:
          (json['ComparePronunciationPercent'] as num?)?.toDouble(),
      percent: (json['Percent'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$StoryPassCharacterToJson(StoryPassCharacter instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'StoryID': instance.storyId,
      'CharacterID': instance.characterId,
      'CharacterName': instance.characterName,
      'UserID': instance.userId,
      'UserName': instance.userName,
      'UserEmail': instance.userEmail,
      'UserCheck': instance.userCheck,
      'CompareEmotionPercent': instance.compareEmotionPercent,
      'CompareBreathPercent': instance.compareBreathPercent,
      'CompareEnergyPercent': instance.compareEnergyPercent,
      'ComparePercent': instance.comparePercent,
      'Percent': instance.percent,
      'ComparePitchPercent': instance.comparePitchPercent,
      'ComparePronunciationPercent': instance.comparePronunciationPercent,
    };
