part of 'plan_pass_cubit.dart';

class PlanPassState extends Equatable {
  const PlanPassState({
    required this.kontinue,
    required this.user,
    required this.step,
    this.loaded = false,
    this.pass,
    this.planId,
    this.cplanId,
    this.planContainsStory,
  });

  final bool loaded;
  final User user;
  final PlanPassModel? pass;
  final int step;
  final String? planId;
  final String? cplanId;
  final bool kontinue;
  final bool? planContainsStory;

  @override
  List<Object?> get props => [
        loaded,
        pass,
        step,
        user,
        planId,
        cplanId,
        kontinue,
        planContainsStory,
      ];

  PlanPassState copyWith({
    bool? loaded,
    PlanPassModel? pass,
    int? step,
    String? planId,
    String? cplanId,
    bool? kontinue,
    bool? planContainsStory,
  }) {
    return PlanPassState(
      loaded: loaded ?? this.loaded,
      user: user,
      pass: pass ?? this.pass,
      step: step ?? this.step,
      planId: planId ?? this.planId,
      cplanId: cplanId ?? this.cplanId,
      kontinue: kontinue ?? this.kontinue,
      planContainsStory: planContainsStory ?? this.planContainsStory,
    );
  }
}
