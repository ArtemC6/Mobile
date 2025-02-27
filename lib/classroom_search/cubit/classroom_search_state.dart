part of 'classroom_search_cubit.dart';

class ClassroomSearchState extends Equatable {
  const ClassroomSearchState({
    this.query = '',
    this.searchClassromPages = const <int, ClassroomSearchPage>{},
    this.userCurrentLanguages = const <UserLanguage>[],
    this.userLanguages = const <UserLanguage>[],
    this.selectedLanguages = const <UserLanguage>[],
    this.selectedLanguages_ = const <UserLanguage>[],
    this.platformLanguageId = '',
    this.sourceLanguages = false,
    this.sourceLanguages_ = false,
  });

  final String query;
  final Map<int, ClassroomSearchPage> searchClassromPages;
  final List<UserLanguage> userCurrentLanguages;
  final List<UserLanguage> selectedLanguages;
  final List<UserLanguage> selectedLanguages_;
  final List<UserLanguage> userLanguages;
  final String platformLanguageId;
  final bool sourceLanguages;
  final bool sourceLanguages_;

  int? get searchClassroomItemsCount {
    if (searchClassromPages.values
        .any((element) => !element.isFull && !element.isLoading)) {
      return searchClassromPages.values
          .map((e) => e.items.length)
          .reduce((value, element) => value + element);
    }

    return null;
  }

  @override
  List<Object?> get props => [
        query,
        searchClassromPages,
        selectedLanguages,
        selectedLanguages_,
        userLanguages.length,
        userCurrentLanguages.length,
        platformLanguageId,
        sourceLanguages,
        sourceLanguages_,
      ];

  ClassroomSearchState copyWith({
    String? query,
    Map<int, ClassroomSearchPage>? searchClassromPages,
    List<UserLanguage>? selectedLanguages,
    List<UserLanguage>? selectedLanguages_,
    List<UserLanguage>? userLanguages,
    List<UserLanguage>? userCurrentLanguages,
    bool? sourceLanguages,
    bool? sourceLanguages_,
    String? platformLanguageId,
  }) {
    return ClassroomSearchState(
      query: query ?? this.query,
      searchClassromPages: searchClassromPages ?? this.searchClassromPages,
      userCurrentLanguages: userCurrentLanguages ?? this.userCurrentLanguages,
      selectedLanguages: selectedLanguages ?? this.selectedLanguages,
      selectedLanguages_: selectedLanguages_ ?? this.selectedLanguages_,
      userLanguages: userLanguages ?? this.userLanguages,
      sourceLanguages: sourceLanguages ?? this.sourceLanguages,
      sourceLanguages_: sourceLanguages_ ?? this.sourceLanguages_,
      platformLanguageId: platformLanguageId ?? this.platformLanguageId,
    );
  }

  ClassroomSearchState copyWithNoFilter() {
    return ClassroomSearchState(
      selectedLanguages: userLanguages,
      selectedLanguages_: userLanguages,
      userLanguages: userLanguages,
      userCurrentLanguages: userCurrentLanguages,
      platformLanguageId: platformLanguageId,
    );
  }
}
