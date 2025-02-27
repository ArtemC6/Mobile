part of 'feed_cubit.dart';

enum FeedTab { feed, challenge, playlist, channel, story }

enum FeedPeriodFilter {
  whenever,
  today,
  yesterday,
  last7days,
  last30days,
  customPeriod,
}

class FeedState extends Equatable {
  const FeedState({
    this.query = '',
    this.tab = FeedTab.feed,
    this.pages = const <int, FeedPage>{},
    this.categories = const <Category>[],
    this.selectedCategory,
    this.userCurrentLanguages = const <UserLanguage>[],
    this.userLanguages = const <UserLanguage>[],
    this.selectedLanguages = const <UserLanguage>[],
    this.author = '',
    this.period = FeedPeriodFilter.whenever,
    this.customPeriodFrom,
    this.customPeriodTo,
    this.levelFrom = 1,
    this.levelTo = 100,
    this.sourceLanguages = false,
    this.sourceLanguages_ = false,
    this.platformLanguageId = '',
    this.storyModeType = -1,
  });

  final String query;
  final FeedTab tab;
  final Map<int, FeedPage> pages;
  final List<Category> categories;
  final String? selectedCategory;
  final List<UserLanguage> selectedLanguages;
  final List<UserLanguage> userLanguages;
  final List<UserLanguage> userCurrentLanguages;
  final String author;
  final FeedPeriodFilter period;
  final DateTime? customPeriodFrom;
  final DateTime? customPeriodTo;
  final int levelFrom;
  final int levelTo;
  final bool sourceLanguages;
  final bool sourceLanguages_;
  final String platformLanguageId;
  final int storyModeType;

  String get periodString {
    switch (period) {
      case FeedPeriodFilter.whenever:
        return S.current.filterPeriodWhenever;
      case FeedPeriodFilter.today:
        return 'Today';
      case FeedPeriodFilter.yesterday:
        return S.current.filterPeriodYesterday;
      case FeedPeriodFilter.last7days:
        return S.current.filterPeriodLast7;
      case FeedPeriodFilter.last30days:
        return S.current.filterPeriodLast30;
      case FeedPeriodFilter.customPeriod:
        return S.current.filterPeriodCustom;
    }
  }

  String get storyModeString {
    switch (storyModeType) {
      case -1:
        return S.current.filterStoryModeAny;
      case 0:
        return S.current.filterStoryModeRoles;
      case 2:
        return S.current.filterStoryModeCertification;
    }
    return S.current.filterStoryModeAny;
  }

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
        query,
        tab,
        pages,
        categories.length,
        selectedCategory,
        selectedLanguages,
        userLanguages.length,
        userCurrentLanguages.length,
        author,
        period,
        customPeriodFrom,
        customPeriodTo,
        levelFrom,
        levelTo,
        sourceLanguages,
        sourceLanguages_,
        platformLanguageId,
        storyModeType,
      ];

  FeedState copyWith({
    String? query,
    FeedTab? tab,
    Map<int, FeedPage>? pages,
    List<Category>? categories,
    String? selectedCategory,
    List<UserLanguage>? selectedLanguages,
    List<UserLanguage>? userLanguages,
    List<UserLanguage>? userCurrentLanguages,
    String? author,
    FeedPeriodFilter? period,
    DateTime? customPeriodFrom,
    DateTime? customPeriodTo,
    int? levelFrom,
    int? levelTo,
    bool? sourceLanguages,
    bool? sourceLanguages_,
    String? platformLanguageId,
    int? storyModeType,
  }) {
    return FeedState(
      query: query ?? this.query,
      tab: tab ?? this.tab,
      pages: pages ?? this.pages,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedLanguages: selectedLanguages ?? this.selectedLanguages,
      userLanguages: userLanguages ?? this.userLanguages,
      userCurrentLanguages: userCurrentLanguages ?? this.userCurrentLanguages,
      author: author ?? this.author,
      period: period ?? this.period,
      customPeriodFrom: customPeriodFrom ?? this.customPeriodFrom,
      customPeriodTo: customPeriodTo ?? this.customPeriodTo,
      levelFrom: levelFrom ?? this.levelFrom,
      levelTo: levelTo ?? this.levelTo,
      sourceLanguages: sourceLanguages ?? this.sourceLanguages,
      sourceLanguages_: sourceLanguages_ ?? this.sourceLanguages_,
      platformLanguageId: platformLanguageId ?? this.platformLanguageId,
      storyModeType: storyModeType ?? this.storyModeType,
    );
  }

  FeedState copyWithNoFilter() {
    return FeedState(
      tab: tab,
      categories: categories,
      selectedLanguages: userLanguages,
      userLanguages: userLanguages,
      userCurrentLanguages: userCurrentLanguages,
      platformLanguageId: platformLanguageId,
    );
  }
}
