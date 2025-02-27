import 'package:voccent/completed_plans/cubit/completed_plans_cubit.dart';
import 'package:voccent/completed_plans/cubit/models/completed_plans_model/finished_plan.dart';

class CompletedPlansPage {
  const CompletedPlansPage({
    this.items = const [],
  });

  final List<FinishedPlan> items;

  bool get isFull => items.length == CompletedPlansCubit.itemsPerPage;

  bool get isLoading => items.isEmpty;
}
