import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:voccent/home/cubit/models/user/user.dart';
import 'package:voccent/http/response_data.dart';
import 'package:voccent/plan_pass/cubit/models/plan_pass_model.dart';
import 'package:voccent/updater_service/updater_service.dart';

part 'plan_pass_state.dart';

class PlanPassCubit extends Cubit<PlanPassState> {
  PlanPassCubit(
    this._updaterService, {
    required this.client,
    required User user,
    required String planId,
    required String cplanId,
    bool kontinue = false,
  }) : super(
          PlanPassState(
            user: user,
            step: 0,
            planId: planId,
            cplanId: cplanId,
            kontinue: kontinue,
          ),
        );

  @override
  void emit(PlanPassState state) {
    if (isClosed) {
      return;
    }
    super.emit(state);
  }

  final Client client;
  final UpdaterService _updaterService;

  Future<void> nextStep() async {
    if (state.step == state.pass!.elements!.length - 1) {
      return;
    }

    emit(state.copyWith(step: state.step + 1));

    await client.post(
      Uri.parse('/api/v1/campus_plan_pass_element'),
      body: {
        'PlanID': state.planId,
        'ElementID': state.pass!.elements![state.step].id,
      },
    );
  }

  Future<void> prevStep() async {
    if (state.step == 0) {
      return;
    }

    emit(state.copyWith(step: state.step - 1));

    await client.post(
      Uri.parse('/api/v1/campus_plan_pass_element'),
      body: {
        'PlanID': state.planId,
        'ElementID': state.pass!.elements![state.step].id,
      },
    );
  }

  Future<void> fetchPlanPass() async {
    final response = await client
        .get(
          Uri.parse(
            '/api/v1/campus_plan_pass/${state.planId}/${state.cplanId}'
            '${state.kontinue ? '?continue=true' : ''}',
          ),
        )
        .mapData();

    final s = (response['Elements'] as List<dynamic>).indexWhere(
      (element) =>
          (element as Map<String, dynamic>)['ID'] ==
          (response['Pass'] as Map<String, dynamic>)['PlanElementID'],
    );
    final containsStory = (response['Elements'] as List<dynamic>).any(
      (element) => (element as Map<String, dynamic>)['Type'] == 'story',
    );

    emit(
      state.copyWith(
        step: s < 0 ? 0 : s,
        loaded: true,
        pass: PlanPassModel.fromJson(response),
        planContainsStory: containsStory,
      ),
    );
  }

  Future<void> finishPlanPass() async {
    await client.get(
      Uri.parse('/api/v1/campus_plan_pass/${state.planId}/${state.cplanId}'),
    );
    _updaterService.updatePlanProgress(state.user);
  }
}
