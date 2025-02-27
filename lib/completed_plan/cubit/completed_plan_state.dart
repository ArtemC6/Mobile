part of 'completed_plan_cubit.dart';

class CompletedPlanState extends Equatable {
  const CompletedPlanState({
    this.finishedPlan,
  });
  final FinishedPlan? finishedPlan;

  @override
  List<Object?> get props => [
        finishedPlan,
      ];
  CompletedPlanState copyWith({
    FinishedPlan? finishedPlan,
  }) {
    return CompletedPlanState(
      finishedPlan: finishedPlan ?? this.finishedPlan,
    );
  }
}
