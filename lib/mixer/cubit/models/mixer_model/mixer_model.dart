import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mixer_model.g.dart';

@JsonSerializable()
class MixerModel extends Equatable {
  const MixerModel({
    this.mixerId,
    this.createdAt,
    this.groupId,
    this.countItems,
    this.mixerItemId,
    this.orderNum,
    this.languageId,
    this.audiosamplerefid,
  });

  factory MixerModel.fromJson(Map<String, dynamic> json) {
    return _$MixerModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MixerModelToJson(this);

  @JsonKey(name: 'MixerID')
  final String? mixerId;
  @JsonKey(name: 'CreatedAt')
  final DateTime? createdAt;
  @JsonKey(name: 'GroupID')
  final String? groupId;
  @JsonKey(name: 'CountItems')
  final int? countItems;
  @JsonKey(name: 'MixerItemID')
  final String? mixerItemId;
  @JsonKey(name: 'OrderNum')
  final double? orderNum;
  @JsonKey(name: 'LanguageID')
  final String? languageId;
  @JsonKey(name: 'Audiosamplerefid')
  final String? audiosamplerefid;

  MixerModel copyWith({
    String? mixerId,
    DateTime? createdAt,
    String? groupId,
    int? countItems,
    String? mixerItemId,
    double? orderNum,
    String? languageId,
    String? audiosamplerefid,
  }) {
    return MixerModel(
      mixerId: mixerId ?? this.mixerId,
      createdAt: createdAt ?? this.createdAt,
      groupId: groupId ?? this.groupId,
      countItems: countItems ?? this.countItems,
      mixerItemId: mixerItemId ?? this.mixerItemId,
      orderNum: orderNum ?? this.orderNum,
      languageId: languageId ?? this.languageId,
      audiosamplerefid: audiosamplerefid ?? this.audiosamplerefid,
    );
  }

  @override
  List<Object?> get props {
    return [
      mixerId,
      createdAt,
      groupId,
      countItems,
      mixerItemId,
      orderNum,
      languageId,
      audiosamplerefid,
    ];
  }
}
