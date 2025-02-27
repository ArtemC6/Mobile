part of 'challenge_cubit.dart';

enum PlayerStatus {
  initial,
  downloading,
  ready,
  failed,
  playing,
}

enum RecorderStatus {
  initial,
  ready,
  starting,
  recording,
  analyzing,
  analyzed,
  failed,
}

const recordingOvertime = Duration(seconds: 1);

class ChallengeState extends Equatable {
  ChallengeState({
    this.challengeUserTicketToken,
    this.recordCount = 0,
    this.refPlayerStatus = PlayerStatus.initial,
    this.testPlayerStatus = PlayerStatus.initial,
    this.highlightPlayerStatus = PlayerStatus.initial,
    this.recorderStatus = RecorderStatus.initial,
    this.challenge,
    this.audiosample,
    this.myAttempts = const <MyAttempt>[],
    this.loadingMyAttempts = false,
    this.loadedMyAttempts = false,
    this.recordingAllowed = true,
    this.currentAnnotationIndex = 0,
    this.rating = 0,
    this.loadingRating = false,
    this.refDuration,
    this.showTranslatedPhrase = false,
    this.playBothAudios = false,
    this.translation = '',
    this.originalPhrase = '',
    this.isInQuota = false,
    this.actualChallengeReference,
    this.offset = 0,
    this.nextBtnVisible = true,
    this.attempt,
  }) {
    var text = '';

    if (refPlayerStatus == PlayerStatus.downloading ||
        testPlayerStatus == PlayerStatus.downloading ||
        highlightPlayerStatus == PlayerStatus.downloading) {
      attemptText = S.current.genericDownloading;
    } else if (recorderStatus == RecorderStatus.analyzing) {
      attemptText = S.current.genericAnalyzing;
    } else if (recorderStatus == RecorderStatus.failed ||
        refPlayerStatus == PlayerStatus.failed ||
        testPlayerStatus == PlayerStatus.failed ||
        highlightPlayerStatus == PlayerStatus.failed) {
      attemptText = S.current.genericFailed1;
    } else if (recorderStatus == RecorderStatus.starting) {
      attemptText = S.current.genericPreparing;
    } else if (recorderStatus == RecorderStatus.recording) {
      attemptText = S.current.genericRecording;
    } else {
      attemptText = S.current.genericRecord;
    }

    if (audiosample?.annotations != null &&
        audiosample!.annotations!.isNotEmpty) {
      final words = audiosample!.annotations!
          .map((e) => e.transcription ?? '')
          .reduce((value, element) => '$value $element');

      text += '\n$words';
    }

    text = text;
  }
  final String? challengeUserTicketToken;
  final int recordCount;
  final PlayerStatus refPlayerStatus;
  final PlayerStatus testPlayerStatus;
  final PlayerStatus highlightPlayerStatus;
  final RecorderStatus recorderStatus;
  final Challenge? challenge;
  final Audiosample? audiosample;
  late final String text;
  late final String attemptText;
  final List<MyAttempt> myAttempts;
  final bool nextBtnVisible;
  final bool loadingMyAttempts;
  final bool loadedMyAttempts;
  final bool recordingAllowed;
  final int currentAnnotationIndex;
  final int rating;
  final bool loadingRating;
  final Duration? refDuration;
  final bool showTranslatedPhrase;
  final bool playBothAudios;
  final String translation;
  final String originalPhrase;
  final bool isInQuota;
  final Uint8List? actualChallengeReference;
  final int offset;
  final ChallengeAttempt? attempt;

  ChallengeState copyWith({
    String? challengeUserTicketToken,
    int? recordCount,
    PlayerStatus? refPlayerStatus,
    PlayerStatus? testPlayerStatus,
    PlayerStatus? highlightPlayerStatus,
    RecorderStatus? recorderStatus,
    Uint8List? refBuffer,
    Uint8List? testBuffer,
    Challenge? challenge,
    Audiosample? audiosample,
    bool? nullChallengeAttempt,
    List<MyAttempt>? myAttempts,
    bool? loadingMyAttempts,
    bool? loadedMyAttempts,
    bool? recordingAllowed,
    int? currentAnnotationIndex,
    int? rating,
    bool? loadingRating,
    Duration? refDuration,
    bool? showTranslatedPhrase,
    bool? playBothAudios,
    String? translation,
    String? originalPhrase,
    bool? isInQuota,
    Uint8List? actualChallengeReference,
    int? offset,
    bool? nextBtnVisible,
    ChallengeAttempt? attempt,
    int? shareWith,
    bool? saveVoiceForShare,
  }) {
    return ChallengeState(
      challengeUserTicketToken:
          challengeUserTicketToken ?? this.challengeUserTicketToken,
      recordCount: recordCount ?? this.recordCount,
      refPlayerStatus: refPlayerStatus ?? this.refPlayerStatus,
      testPlayerStatus: testPlayerStatus ?? this.testPlayerStatus,
      highlightPlayerStatus:
          highlightPlayerStatus ?? this.highlightPlayerStatus,
      recorderStatus: recorderStatus ?? this.recorderStatus,
      challenge: challenge ?? this.challenge,
      audiosample: audiosample ?? this.audiosample,
      myAttempts: myAttempts ?? this.myAttempts,
      loadingMyAttempts: loadingMyAttempts ?? this.loadingMyAttempts,
      nextBtnVisible: nextBtnVisible ?? this.nextBtnVisible,
      loadedMyAttempts: loadedMyAttempts ?? this.loadedMyAttempts,
      recordingAllowed: recordingAllowed ?? this.recordingAllowed,
      currentAnnotationIndex:
          currentAnnotationIndex ?? this.currentAnnotationIndex,
      rating: rating ?? this.rating,
      loadingRating: loadingRating ?? this.loadingRating,
      refDuration: refDuration ?? this.refDuration,
      showTranslatedPhrase: showTranslatedPhrase ?? this.showTranslatedPhrase,
      playBothAudios: playBothAudios ?? this.playBothAudios,
      translation: translation ?? this.translation,
      originalPhrase: originalPhrase ?? this.originalPhrase,
      isInQuota: isInQuota ?? this.isInQuota,
      actualChallengeReference:
          actualChallengeReference ?? this.actualChallengeReference,
      offset: offset ?? this.offset,
      attempt: attempt ?? this.attempt,
    );
  }

  @override
  List<Object?> get props => [
        challengeUserTicketToken,
        refPlayerStatus,
        testPlayerStatus,
        highlightPlayerStatus,
        recorderStatus,
        audiosample,
        myAttempts.length,
        loadingMyAttempts,
        loadedMyAttempts,
        recordingAllowed,
        challenge,
        currentAnnotationIndex,
        rating,
        loadingRating,
        refDuration,
        showTranslatedPhrase,
        playBothAudios,
        translation,
        originalPhrase,
        isInQuota,
        actualChallengeReference?.length,
        offset,
        nextBtnVisible,
        attempt,
      ];
  double annotationAvgPronunciation() {
    final list = attempt!.pronunciationSeries[0].dataSource!.where(
      (element) =>
          element.segmentStart >
              audiosample!.annotations![currentAnnotationIndex].segmentStart! &&
          element.segmentEnd <
              audiosample!.annotations![currentAnnotationIndex].segmentEnd!,
    );

    if (list.isEmpty) {
      return 0;
    }

    final sum = list
        .map((e) => e.combinedPronunciation)
        .reduce((value, element) => value + element);

    return sum / list.length;
  }

  double annotationAvgEnergy() {
    final list = attempt!.energySeries[0].dataSource!.where(
      (element) =>
          element.segmentStart >
              audiosample!.annotations![currentAnnotationIndex].segmentStart! &&
          element.segmentEnd <
              audiosample!.annotations![currentAnnotationIndex].segmentEnd!,
    );

    if (list.isEmpty) {
      return 0;
    }

    final sum =
        list.map((e) => e.energy).reduce((value, element) => value + element);

    final result = sum / list.length;

    return result;
  }

  double annotationAvgPitch() {
    final list = attempt!.pitchSeries[0].dataSource!.where(
      (element) =>
          element.segmentStart >
              audiosample!.annotations![currentAnnotationIndex].segmentStart! &&
          element.segmentEnd <
              audiosample!.annotations![currentAnnotationIndex].segmentEnd!,
    );

    if (list.isEmpty) {
      return 0;
    }

    final sum =
        list.map((e) => e.pitch).reduce((value, element) => value + element);

    final result = sum / list.length;

    return result;
  }

  double annotationAvgPronunciationByIndex(int index) {
    final list = attempt!.pronunciationSeries[0].dataSource!.where(
      (element) =>
          element.segmentStart >
              audiosample!.annotations![index].segmentStart! &&
          element.segmentEnd < audiosample!.annotations![index].segmentEnd!,
    );

    if (list.isEmpty) {
      return 0;
    }

    final sum = list
        .map((e) => e.combinedPronunciation)
        .reduce((value, element) => value + element);

    return sum / list.length;
  }

  double blur(double maxValue) {
    if (myAttempts.isEmpty) {
      return maxValue;
    }

    return max(maxValue - myAttempts.last.totalPercent, 0);
  }
}
