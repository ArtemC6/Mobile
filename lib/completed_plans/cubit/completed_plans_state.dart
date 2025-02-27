part of 'completed_plans_cubit.dart';

enum CompletedPlansStatus { initial, isEmpty }

class CompletedPlansState extends Equatable {
  const CompletedPlansState({
    this.pages = const <int, CompletedPlansPage>{},
    this.status = CompletedPlansStatus.initial,
    this.error,
  });

  final Map<int, CompletedPlansPage> pages;
  final CompletedPlansStatus status;
  final String? error;
  int? get itemsCount {
    if (pages.values.any((element) => !element.isFull && !element.isLoading)) {
      return pages.values
          .map((e) => e.items.length)
          .reduce((value, element) => value + element);
    }

    return null;
  }

  @override
  List<Object?> get props => [
        pages,
      ];

  CompletedPlansState copyWith({
    List<FinishedPlan>? finishedPlans,
    Map<int, CompletedPlansPage>? pages,
    CompletedPlansStatus? status,
    String? error,
  }) {
    return CompletedPlansState(
      pages: pages ?? this.pages,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
