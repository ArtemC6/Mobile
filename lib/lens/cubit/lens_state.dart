part of 'lens_cubit.dart';

enum RecommendationItemType { challenge, playlist, story }

enum ItemType { challenge, playlist, channel, story, classroom }

class LensState extends Equatable {
  const LensState({
    this.languageId,
    this.languageName = '',
    this.itemType = RecommendationItemType.challenge,
    this.groupId = '',
    this.mixerModel,
    this.refresh = false,
    this.currentIndex = 0,
    this.classroom = const <ClassroomSearchModel>[],
    this.recommendationsItem = const <RecommendationsItem>[],
    this.userCompareLevel = const <CompareLevel>[],
    this.countCompareByDate = const <CountCompareByDate>[],
    this.myClassrooms = const <MyClassroom>[],
    this.recentClassrooms = const <String>[],
    this.recentChallenges = const <Challenge>[],
    this.recentStories = const <Story>[],
    this.recentPlaylists = const <Playlist>[],
    this.recentChannels = const <FeedObject>[],
  });

  final String? languageId;
  final String languageName;
  final RecommendationItemType itemType;
  final String? groupId;
  final MixerModel? mixerModel;
  final bool? refresh;
  final int currentIndex;
  final List<ClassroomSearchModel> classroom;
  final List<RecommendationsItem> recommendationsItem;
  final List<CompareLevel> userCompareLevel;
  final List<CountCompareByDate> countCompareByDate;
  final List<MyClassroom> myClassrooms;
  final List<String> recentClassrooms;
  final List<Challenge> recentChallenges;
  final List<Story> recentStories;
  final List<Playlist> recentPlaylists;
  final List<FeedObject> recentChannels;

  @override
  List<Object?> get props => [
        languageId,
        languageName,
        itemType,
        groupId,
        mixerModel,
        refresh,
        currentIndex,
        classroom.length,
        recommendationsItem.length,
        userCompareLevel,
        countCompareByDate,
        myClassrooms,
        recentClassrooms,
        recentChallenges,
        recentStories,
        recentPlaylists,
        recentChannels,
      ];

  LensState copyWith({
    String? languageId,
    String? languageName,
    RecommendationItemType? itemType,
    String? groupId,
    MixerModel? mixerModel,
    bool? refresh,
    int? currentIndex,
    List<ClassroomSearchModel>? classroom,
    List<RecommendationsItem>? recommendationsItem,
    List<CompareLevel>? userCompareLevel,
    List<CountCompareByDate>? countCompareByDate,
    List<MyClassroom>? myClassrooms,
    List<String>? recentClassrooms,
    List<Challenge>? recentChallenges,
    List<Story>? recentStories,
    List<Playlist>? recentPlaylists,
    List<FeedObject>? recentChannels,
  }) {
    return LensState(
      languageId: languageId ?? this.languageId,
      languageName: languageName ?? this.languageName,
      itemType: itemType ?? this.itemType,
      groupId: groupId ?? this.groupId,
      mixerModel: mixerModel ?? this.mixerModel,
      refresh: refresh ?? this.refresh,
      currentIndex: currentIndex ?? this.currentIndex,
      classroom: classroom ?? this.classroom,
      recommendationsItem: recommendationsItem ?? this.recommendationsItem,
      userCompareLevel: userCompareLevel ?? this.userCompareLevel,
      countCompareByDate: countCompareByDate ?? this.countCompareByDate,
      myClassrooms: myClassrooms ?? this.myClassrooms,
      recentClassrooms: recentClassrooms ?? this.recentClassrooms,
      recentChallenges: recentChallenges ?? this.recentChallenges,
      recentStories: recentStories ?? this.recentStories,
      recentPlaylists: recentPlaylists ?? this.recentPlaylists,
      recentChannels: recentChannels ?? this.recentChannels,
    );
  }
}
