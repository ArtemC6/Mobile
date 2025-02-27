import 'package:voccent/classroom_search/cubit/classroom_search_cubit.dart';
import 'package:voccent/classroom_search/cubit/models/classroom_search_model.dart';

class ClassroomSearchPage {
  const ClassroomSearchPage({
    required this.isLoading,
    this.items = const [],
  });

  final List<ClassroomSearchModel> items;

  bool get isFull => items.length == ClassroomSearchCubit.itemsPerPage;

  final bool isLoading;
}
