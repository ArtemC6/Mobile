import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:voccent/feed/cubit/models/feed_model/feed_object.dart';

part 'feed_model.g.dart';

@JsonSerializable()
class FeedModel extends Equatable {
  const FeedModel({
    this.id,
    this.type,
    this.createdBy,
    this.sourceLanguageGroup,
    this.object,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return _$FeedModelFromJson(json);
  }
  @JsonKey(name: 'ID')
  final String? id;
  @JsonKey(name: 'Type')
  final String? type;
  @JsonKey(name: 'CreatedBy')
  final String? createdBy;
  @JsonKey(name: 'SourceLanguageGroup')
  final int? sourceLanguageGroup;
  @JsonKey(name: 'Object')
  final FeedObject? object;

  Map<String, dynamic> toJson() => _$FeedModelToJson(this);

  bool isLoading() => id == null;

  @override
  List<Object?> get props => [id, type, createdBy, sourceLanguageGroup, object];
}
