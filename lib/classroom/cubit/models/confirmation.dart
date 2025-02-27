import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'confirmation.g.dart';

@JsonSerializable()
class Confirmation extends Equatable {
  const Confirmation({
    this.id,
    this.objectId,
    // this.permissions,
    this.sharedWith,
    this.sharedWithEmail,
    this.sharedWithName,
    this.status,
    this.type,
  });

  factory Confirmation.fromJson(Map<String, dynamic> json) =>
      _$ConfirmationFromJson(json);
  Map<String, dynamic> toJson() => _$ConfirmationToJson(this);

  @JsonKey(name: 'ID')
  final String? id;
  @JsonKey(name: 'ObjectID')
  final String? objectId;
  // @JsonKey(name: 'Permissions')
  // final String? permissions;
  @JsonKey(name: 'SharedWith')
  final String? sharedWith;
  @JsonKey(name: 'SharedWithEmail')
  final String? sharedWithEmail;
  @JsonKey(name: 'SharedWithName')
  final String? sharedWithName;
  @JsonKey(name: 'Status')
  final String? status;
  @JsonKey(name: 'Type')
  final String? type;

  @override
  List<Object?> get props => [
        id,
        objectId,
        // permissions,
        sharedWith,
        sharedWithEmail,
        sharedWithName,
        status,
        type,
      ];
}
