import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:voccent/completed_plans/cubit/models/completed_plans_model/finished_plan.dart';
import 'package:voccent/http/response_data.dart';

part 'completed_plan_state.dart';

class CompletedPlanCubit extends Cubit<CompletedPlanState> {
  CompletedPlanCubit({
    required Client client,
  })  : _client = client,
        super(const CompletedPlanState());

  final Client _client;
  Future<void> fetchCompletedPlan(String planId) async {
    final plan = await _fetchFinishedPlans(planId);

    emit(
      state.copyWith(
        finishedPlan: plan,
      ),
    );
  }

  Future<FinishedPlan> _fetchFinishedPlans(String passId) async {
    final response = (await _client
            .get(
              Uri.parse(
                '/api/v1/campus_plan_pass/list?ID=$passId',
              ),
            )
            .listData())
        .map((e) => FinishedPlan.fromJson(e as Map<String, dynamic>));

    return response.toList().first;
  }
}
