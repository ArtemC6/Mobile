part of 'playlist_cubit.dart';

enum PlaylistStatus {
  initial,
  loadingPlaylist,
  loadingChallenge,
  readyPlaylist,
  readyChallenge,
  playingRef,
  startingRecord,
  recording,
  analyzing,
  finished,
  failed,
  analyzationFailed,
}

const recordingOvertime = Duration(seconds: 1);

class PlaylistState extends Equatable {
  const PlaylistState({
    this.errorMessage,
    this.errorAt,
    this.status = PlaylistStatus.initial,
    this.playlist,
    this.selectedChallengeIndex = 0,
    this.audiosample,
    this.recordingAllowed = true,
    this.recordCount = 0,
    this.myAttempts = const <MyAttempt>[],
    this.isAutoplay = false,
    this.currentAnnotationIndex = 0,
    this.emotion,
    this.fingerprint,
    this.refDuration = Duration.zero,
    this.isPlaying = false,
  });

  final String? errorMessage;
  final DateTime? errorAt;
  final PlaylistStatus status;
  final Playlist? playlist;
  final int selectedChallengeIndex;
  final Audiosample? audiosample;
  final bool recordingAllowed;
  final int recordCount;
  final List<MyAttempt> myAttempts;
  final bool isAutoplay;
  final int currentAnnotationIndex;
  final Duration? refDuration;
  final Fingerprint? fingerprint;
  final EmotionData? emotion;
  final bool isPlaying;

  double blur(double maxValue) {
    if (myAttempts.isEmpty) {
      return maxValue;
    }

    return max(maxValue - myAttempts.last.totalPercent, 0);
  }

  MyAttempt? get myLastAttempt {
    if (myAttempts.isEmpty) return null;
    return myAttempts.last;
  }

  PlaylistState copyWith({
    String? errorMessage,
    PlaylistStatus? status,
    Playlist? playlist,
    int? selectedChallengeIndex,
    Audiosample? audiosample,
    bool? recordingAllowed,
    int? recordCount,
    List<MyAttempt>? myAttempts,
    bool? nullChallengeAttempt,
    bool? isAutoplay,
    int? currentAnnotationIndex,
    Fingerprint? fingerprint,
    EmotionData? emotion,
    Duration? refDuration,
    bool? isPlaying,
  }) {
    return PlaylistState(
      errorMessage: errorMessage ?? this.errorMessage,
      errorAt: errorMessage != null ? DateTime.now() : null,
      status: status ?? this.status,
      playlist: playlist ?? this.playlist,
      selectedChallengeIndex:
          selectedChallengeIndex ?? this.selectedChallengeIndex,
      audiosample: audiosample ?? this.audiosample,
      recordingAllowed: recordingAllowed ?? this.recordingAllowed,
      recordCount: recordCount ?? this.recordCount,
      isAutoplay: isAutoplay ?? this.isAutoplay,
      refDuration: refDuration ?? this.refDuration,
      currentAnnotationIndex:
          currentAnnotationIndex ?? this.currentAnnotationIndex,
      // ignore: use_if_null_to_convert_nulls_to_bools
      myAttempts: nullChallengeAttempt == true
          ? <MyAttempt>[]
          : myAttempts ?? this.myAttempts,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  @override
  List<Object?> get props => [
        errorMessage,
        errorAt,
        status,
        selectedChallengeIndex,
        recordingAllowed,
        audiosample,
        errorMessage,
        isAutoplay,
        playlist,
        currentAnnotationIndex,
        fingerprint,
        emotion,
        refDuration,
        isPlaying,
      ];
}
