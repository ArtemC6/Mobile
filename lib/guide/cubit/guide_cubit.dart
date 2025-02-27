import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:voccent/feed/cubit/models/category.dart';
import 'package:voccent/http/response_data.dart';

part 'guide_state.dart';

class GuideCubit extends Cubit<GuideState> {
  GuideCubit(
    this._client,
  ) : super(const GuideState());

  final Client _client;

  Future<void> loadFilters() async {
    if (state.categories.isEmpty) {
      await _fetchCategoryTree();
    }
  }

  Future<void> _fetchCategoryTree() async {
    final response =
        await _client.get(Uri.parse('/api/v1/category/tree')).listData();

    final categoryTree = response
        .map(
          (dynamic e) => Category.fromJson(e as Map<String, dynamic>),
        )
        .toList();

    emit(
      state.copyWith(
        categories: categoryTree,
        selectedCategory: const Category(),
      ),
    );
  }

  void setCategoryFilter(Category category) =>
      emit(state.copyWith(selectedCategory: category));
}
