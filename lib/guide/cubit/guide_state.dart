part of 'guide_cubit.dart';

class GuideState extends Equatable {
  const GuideState({
    this.categories = const <Category>[],
    this.selectedCategory = const Category(),
  });

  final Category selectedCategory;
  final List<Category> categories;

  GuideState copyWith({
    List<Category>? categories,
    Category? selectedCategory,
  }) {
    return GuideState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object> get props => [
        categories.length,
        selectedCategory,
      ];
}
