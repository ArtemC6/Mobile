part of 'streamotion_cubit.dart';

/* TODO(svic): Make it a coefficient 6.8; each time we got the new
IntervalMS update, recalculate the resulted threshold.*/
const int vadThreshold = 34000;

class StreamotionState extends Equatable {
  const StreamotionState({
    this.streamotionUserTicketToken,
    this.recorderState = RecorderState.isStopped,
    this.secondaryEmotions = const <String>[
      'Neutral',
      'Neutral',
      'Neutral',
    ],
    this.emotion,
    this.blobLength = 0,
    this.isChartVisible = true,
    this.verdict = '',
    this.distances = const [],
    this.isMicGranted = true,
  });

  final List<String> secondaryEmotions;

  final String? streamotionUserTicketToken;
  final String verdict;
  final RecorderState recorderState;
  final StreamotionCompareModel? emotion;
  final int blobLength;
  final bool isChartVisible;
  final List<Map<String, double>> distances;
  final bool isMicGranted;

  @override
  List<Object?> get props => [
        streamotionUserTicketToken,
        recorderState,
        secondaryEmotions,
        emotion,
        blobLength,
        isChartVisible,
        verdict,
        distances,
        isMicGranted,
      ];

  StreamotionState copyWith({
    bool? nullStreamotionUserTicketToken,
    String? streamotionUserTicketToken,
    RecorderState? recorderState,
    List<String>? secondaryEmotions,
    StreamotionCompareModel? emotion,
    int? blobLength,
    bool? isChartVisible,
    String? verdict,
    List<Map<String, double>>? distances,
    bool? isMicGranted,
  }) {
    return StreamotionState(
      streamotionUserTicketToken: nullStreamotionUserTicketToken ?? false
          ? null
          : streamotionUserTicketToken ?? this.streamotionUserTicketToken,
      recorderState: recorderState ?? this.recorderState,
      secondaryEmotions: secondaryEmotions ?? this.secondaryEmotions,
      emotion: emotion ?? this.emotion,
      blobLength: blobLength ?? this.blobLength,
      isChartVisible: isChartVisible ?? this.isChartVisible,
      verdict: verdict ?? this.verdict,
      distances: distances ?? this.distances,
      isMicGranted: isMicGranted ?? this.isMicGranted,
    );
  }
}
