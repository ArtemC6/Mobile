import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:voccent/pagination/pagination_state.dart';

/// Abstract PaginationCubit that can be used in other cubits
/// where pagination is needed.
/// In the cubit that inherits from this abstract class,
/// it is necessary to implement the loadDataList method,
/// in which the logic of fetch list
abstract class PaginationCubit<TLoaded>
    extends Cubit<PaginationState<TLoaded>> {
  PaginationCubit() : super(PaginationState<TLoaded>()) {
    _streamController.stream.listen((_) => fetch());
  }
  final _streamController = StreamController<void>();

  Future<void> fetch() async {
    if (state.hasReachedMax || _streamController.isClosed) return;
    try {
      final list = await loadDataList(
        state.status == Status.initial ? 0 : state.list.length,
      );
      if (!_streamController.isClosed) {
        emit(
          state.copyWith(
            status: Status.success,
            list: List.of(state.list)..addAll(list),
            hasReachedMax: hasReachedMax(list),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          error: e,
        ),
      );
    }
  }

  @protected
  Future<List<TLoaded>> loadDataList([int offset = 0]);

  @protected
  int get limit => 10;

  ///The variable 'hasReachedMax' indicates that we have reached
  ///the end of the entire list; when true, no more requests are made
  @protected
  bool hasReachedMax(List<TLoaded> newDataList) =>
      newDataList.isEmpty || newDataList.length < limit;

  @override
  Future<void> close() {
    _streamController.close();
    return super.close();
  }
}
