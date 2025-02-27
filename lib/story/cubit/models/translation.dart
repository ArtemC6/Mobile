import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'translation.g.dart';

@JsonSerializable()
class Translation extends Equatable {
  const Translation({
    this.phrase = '',
  });

  factory Translation.fromJson(Map<String, dynamic> json) =>
      _$TranslationFromJson(json);
  Map<String, dynamic> toJson() => _$TranslationToJson(this);

  @JsonKey(name: 'Phrase')
  final String phrase;

  @override
  List<Object?> get props => [phrase];
}
