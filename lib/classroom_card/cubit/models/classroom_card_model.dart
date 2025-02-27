import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'classroom_card_model.g.dart';

@JsonSerializable()
class ClassroomCardClassroomModel extends Equatable {
  const ClassroomCardClassroomModel({
    this.id,
    this.createdat,
    this.createdby,
    this.name,
    this.description,
    this.members,
    this.plans,
    this.rating,
    this.countRating,
    this.autoAccept,
  });

  factory ClassroomCardClassroomModel.fromJson(Map<String, dynamic> json) {
    return _$ClassroomCardClassroomModelFromJson(json);
  }

  @JsonKey(name: 'ID')
  final String? id;
  @JsonKey(name: 'createdat')
  final DateTime? createdat;
  @JsonKey(name: 'createdby')
  final String? createdby;
  @JsonKey(name: 'Name')
  final String? name;
  @JsonKey(name: 'Description')
  final String? description;
  @JsonKey(name: 'Members')
  final int? members;
  @JsonKey(name: 'Plans')
  final int? plans;
  @JsonKey(name: 'Rating')
  final double? rating;
  @JsonKey(name: 'CountRating')
  final int? countRating;
  @JsonKey(name: 'AutoAccept')
  final bool? autoAccept;

  Map<String, dynamic> toJson() => _$ClassroomCardClassroomModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        createdat,
        createdby,
        name,
        description,
        members,
        plans,
        rating,
        countRating,
        autoAccept,
      ];
}

@JsonSerializable()
class ClassroomCardConfirmationModel extends Equatable {
  const ClassroomCardConfirmationModel({
    this.status,
  });

  factory ClassroomCardConfirmationModel.fromJson(Map<String, dynamic> json) {
    return _$ClassroomCardConfirmationModelFromJson(json);
  }

  @JsonKey(name: 'Status')
  final String? status;

  Map<String, dynamic> toJson() => _$ClassroomCardConfirmationModelToJson(this);

  @override
  List<Object?> get props => [
        status,
      ];
}

@JsonSerializable()
class ClassroomCardPlanModel extends Equatable {
  const ClassroomCardPlanModel({
    this.classroomId,
    this.createdat,
    this.createdby,
    this.name,
    this.description,
    this.elementCount,
    this.campusName,
    this.startAt,
    this.endAt,
    this.userPassing,
    this.planId,
    this.userPassingScore,
    this.userPassedTopScore,
    this.orderNum,
    this.monetization,
  });

  factory ClassroomCardPlanModel.fromJson(Map<String, dynamic> json) =>
      _$ClassroomCardPlanModelFromJson(json);

  @JsonKey(name: 'ID')
  final String? classroomId;
  @JsonKey(name: 'createdat')
  final DateTime? createdat;
  @JsonKey(name: 'createdby')
  final String? createdby;
  @JsonKey(name: 'Name')
  final String? name;
  @JsonKey(name: 'Description')
  final String? description;
  @JsonKey(name: 'ElementCount')
  final int? elementCount;
  @JsonKey(name: 'CampusName')
  final String? campusName;
  @JsonKey(name: 'StartAt')
  final DateTime? startAt;
  @JsonKey(name: 'EndAt')
  final DateTime? endAt;
  @JsonKey(name: 'UserPassing')
  final bool? userPassing;
  @JsonKey(name: 'UserPassingScore')
  final double? userPassingScore;
  @JsonKey(name: 'PlanID')
  final String? planId;
  @JsonKey(name: 'UserPassedTopScore')
  final double? userPassedTopScore;
  @JsonKey(name: 'OrderNum')
  final int? orderNum;
  @JsonKey(name: 'Monetization')
  final bool? monetization;

  Map<String, dynamic> toJson() => _$ClassroomCardPlanModelToJson(this);

  @override
  List<Object?> get props => [
        classroomId,
        createdat,
        createdby,
        name,
        description,
        elementCount,
        campusName,
        startAt,
        endAt,
        userPassing,
        userPassingScore,
        planId,
        userPassedTopScore,
        orderNum,
        monetization,
      ];

  ClassroomCardPlanModel copyWith({
    String? classroomId,
    DateTime? createdat,
    String? createdby,
    String? name,
    String? description,
    int? elementCount,
    String? campusName,
    DateTime? startAt,
    DateTime? endAt,
    bool? userPassing,
    double? userPassingScore,
    String? planId,
    double? userPassedTopScore,
    int? orderNum,
    bool? monetization,
  }) {
    return ClassroomCardPlanModel(
      classroomId: classroomId ?? this.classroomId,
      createdat: createdat ?? this.createdat,
      createdby: createdby ?? this.createdby,
      name: name ?? this.name,
      description: description ?? this.description,
      elementCount: elementCount ?? this.elementCount,
      campusName: campusName ?? this.campusName,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      userPassing: userPassing ?? this.userPassing,
      userPassingScore: userPassingScore ?? this.userPassingScore,
      planId: planId ?? this.planId,
      userPassedTopScore: userPassedTopScore ?? this.userPassedTopScore,
      orderNum: orderNum ?? this.orderNum,
      monetization: monetization ?? this.monetization,
    );
  }
}

@JsonSerializable()
class ClassroomCardModel extends Equatable {
  const ClassroomCardModel({
    this.classroom,
    this.languageIds,
    this.confirmation,
    this.currentPlans,
  });

  factory ClassroomCardModel.fromJson(Map<String, dynamic> json) {
    return _$ClassroomCardModelFromJson(json);
  }

  @JsonKey(name: 'Classroom')
  final ClassroomCardClassroomModel? classroom;
  @JsonKey(name: 'LanguageIDs')
  final List<String>? languageIds;
  @JsonKey(name: 'Confirmation')
  final ClassroomCardConfirmationModel? confirmation;
  @JsonKey(name: 'CurrentPlans')
  final List<ClassroomCardPlanModel>? currentPlans;

  Map<String, dynamic> toJson() => _$ClassroomCardModelToJson(this);

  @override
  List<Object?> get props => [
        classroom,
        languageIds,
        confirmation,
        currentPlans,
      ];

  ClassroomCardModel copyWith({
    ClassroomCardClassroomModel? classroom,
    List<String>? languageIds,
    ClassroomCardConfirmationModel? confirmation,
    List<ClassroomCardPlanModel>? currentPlans,
  }) {
    return ClassroomCardModel(
      classroom: classroom ?? this.classroom,
      languageIds: languageIds ?? this.languageIds,
      confirmation: confirmation ?? this.confirmation,
      currentPlans: currentPlans ?? this.currentPlans,
    );
  }
}
