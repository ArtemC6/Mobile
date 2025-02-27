part of 'mixer_cubit.dart';

const recordingOvertime = Duration(seconds: 1);

class MixerState extends Equatable {
  MixerState({
    this.model,
    this.step = 0,
    this.refPlayerStatus = PlayerStatus.initial,
    this.testPlayerStatus = PlayerStatus.initial,
    this.recorderStatus = RecorderStatus.initial,
    this.recordingAllowed = true,
    this.recordCount = 0,
    this.refDuration,
    this.showTranslatedPhrase = false,
    this.translation = '',
    this.originalPhrase = '',
    this.translationLoaded = false,
    this.fingerprint,
    this.emotion,
  }) {
    if (refPlayerStatus == PlayerStatus.downloading ||
        testPlayerStatus == PlayerStatus.downloading) {
      attemptText = S.current.genericDownloading;
    } else if (recorderStatus == RecorderStatus.analyzing) {
      attemptText = S.current.genericAnalyzing;
    } else if (recorderStatus == RecorderStatus.failed ||
        refPlayerStatus == PlayerStatus.failed ||
        testPlayerStatus == PlayerStatus.failed) {
      attemptText = S.current.genericFailed1;
    } else if (recorderStatus == RecorderStatus.starting) {
      attemptText = S.current.genericPreparing;
    } else if (recorderStatus == RecorderStatus.recording) {
      attemptText = S.current.genericRecording;
    } else {
      attemptText = S.current.genericRecord;
    }
  }

  final MixerModel? model;
  final int step;
  final PlayerStatus refPlayerStatus;
  final PlayerStatus testPlayerStatus;
  final RecorderStatus recorderStatus;
  final bool recordingAllowed;
  final int recordCount;
  final Duration? refDuration;
  late final String attemptText;
  final bool showTranslatedPhrase;
  final String translation;
  final String originalPhrase;
  final bool translationLoaded;
  final Fingerprint? fingerprint;
  final EmotionData? emotion;

  MixerState copyWith({
    MixerModel? model,
    int? step,
    bool? noResult,
    PlayerStatus? refPlayerStatus,
    PlayerStatus? testPlayerStatus,
    RecorderStatus? recorderStatus,
    bool? recordingAllowed,
    int? recordCount,
    Duration? refDuration,
    bool? showTranslatedPhrase,
    String? translation,
    String? originalPhrase,
    bool? translationLoaded,
    Fingerprint? fingerprint,
    EmotionData? emotion,
  }) {
    return MixerState(
      model: model ?? this.model,
      step: step ?? this.step,
      refPlayerStatus: refPlayerStatus ?? this.refPlayerStatus,
      testPlayerStatus: testPlayerStatus ?? this.testPlayerStatus,
      recorderStatus: recorderStatus ?? this.recorderStatus,
      recordingAllowed: recordingAllowed ?? this.recordingAllowed,
      recordCount: recordCount ?? this.recordCount,
      refDuration: refDuration ?? this.refDuration,
      showTranslatedPhrase: showTranslatedPhrase ?? this.showTranslatedPhrase,
      translation: translation ?? this.translation,
      originalPhrase: originalPhrase ?? this.originalPhrase,
      translationLoaded: translationLoaded ?? this.translationLoaded,
      fingerprint: fingerprint ?? this.fingerprint,
      emotion: emotion ?? this.emotion,
    );
  }

  @override
  List<Object?> get props => [
        model,
        step,
        refPlayerStatus,
        testPlayerStatus,
        recorderStatus,
        recordingAllowed,
        recordCount,
        refDuration,
        showTranslatedPhrase,
        translation,
        originalPhrase,
        translationLoaded,
        fingerprint,
        emotion,
      ];
}
