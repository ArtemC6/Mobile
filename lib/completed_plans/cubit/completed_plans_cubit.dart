import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:voccent/completed_plans/cubit/models/completed_plans_model/finished_plan.dart';
import 'package:voccent/completed_plans/cubit/models/completed_plans_page.dart';
import 'package:voccent/http/response_data.dart';

part 'completed_plans_state.dart';

class CompletedPlansCubit extends Cubit<CompletedPlansState> {
  CompletedPlansCubit({
    required Client client,
  })  : _client = client,
        super(const CompletedPlansState());
  static const itemsPerPage = 20;
  final Client _client;

  Future<void> fetchInitialData() async {
    final queryParameters = <String, dynamic>{
      'offset': '0',
      'limit': '$itemsPerPage',
    };
    const uriString = '/api/v1/campus_plan_pass/list';

    final uri = Uri.parse(uriString).replace(queryParameters: queryParameters);
    final response = await _client.get(uri).listData();
    if (response.isEmpty) {
      emit(
        state.copyWith(
          status: CompletedPlansStatus.isEmpty,
        ),
      );
    }
  }

  FinishedPlan feedItem(int index) {
    // Compute the starting index of the page where this challenge is located.
    // For example, if [index] is `42` and [itemsPerPage] is `20`,
    // then `index ~/ itemsPerPage` (integer division)
    // evaluates to `2`, and `2 * 20` is `40`.
    final startingIndex = (index ~/ itemsPerPage) * itemsPerPage;

    // If the corresponding page is already in memory, return immediately.
    if (state.pages[startingIndex]?.isLoading == false) {
      return state.pages[startingIndex]!.items[index - startingIndex];
    } else if (!state.pages.containsKey(startingIndex)) {
      // We don't have the data yet. Start fetching it.
      _loadPage(startingIndex);
    }

    // In the meantime, return a placeholder.
    return const FinishedPlan();
  }

  /// This method initiates fetching of the [FinishedPlan]
  /// at [startingIndex].
  Future<void> _loadPage(int startingIndex) async {
    if (state.pages[startingIndex]?.isLoading ?? false) {
      // Page is already being fetched. Ignore the redundant call.
      return;
    }

    try {
      final page = await _fetchPage(startingIndex);
      // Store the new page and set status to Loaded.
      emit(
        state.copyWith(
          pages: Map<int, CompletedPlansPage>.from(state.pages)
            ..[startingIndex] = page,
        ),
      );
    } catch (e) {
      // ignore
    }
  }

  Future<CompletedPlansPage> _fetchPage(int startingIndex) async {
    final queryParameters = <String, dynamic>{
      'offset': '$startingIndex',
      'limit': '$itemsPerPage',
    };
    const uriString = '/api/v1/campus_plan_pass/list';

    final uri = Uri.parse(uriString).replace(queryParameters: queryParameters);
    final response = await _client.get(uri).listData();
    final items = response
        .map((e) => FinishedPlan.fromJson(e as Map<String, dynamic>))
        .toList();
    if (items.isEmpty) {
      emit(
        state.copyWith(
          status: CompletedPlansStatus.isEmpty,
        ),
      );
    }
    return CompletedPlansPage(
      items: items,
    );
  }
}
