part of 'story_cubit.dart';

const recordingOvertime = Duration(seconds: 1);

enum VideoLoadingStatus { initial, loading, finished }

enum RecorderError { success, failed }

class StoryState extends Equatable {
  const StoryState({
    this.storyPassUpdateTicketToken,
    this.storyPassReadTicketToken,
    this.storyPass = const StoryPass(),
    this.invites = const [],
    this.skipPauseVote,
    this.storyPassCharacters = const <String, StoryPassCharacter>{},
    this.currentPass,
    this.quizDataToSend = const ItemPassQuiz(),
    this.conditionTimer = 0,
    this.isOnlineUser = const <String, bool>{},
    this.loading = false,
    this.isAutoStart = false,
    this.isInQuota = true,
    this.story,
    this.chosenAct,
    this.modes = const [],
    this.isTestAudiosampleLinkedToItemPass = false,
    this.storyId,
    this.refPlayerStatus = PlayerState.isStopped,
    this.testPlayerStatus = PlayerState.isStopped,
    this.highlightPlayerStatus = PlayerState.isStopped,
    this.recorderStatus = RecorderState.isStopped,
    this.audiosampleRefDuration = Duration.zero,
    this.isInteractiveVideo = false,
    this.isVideoOnBackground = false,
    this.isImageOnBackground = false,
    this.videosample,
    this.videosampleFilePath = '',
    this.status = VideoLoadingStatus.initial,
    this.isback2Unmuted = true,
    this.invitedUsers = const [],
    this.isFullRecording = true,
    this.isNextScreen = false,
    this.semanticAnalysisPercent = 0,
    this.recordingAllowed = true,
    this.recorderError = RecorderError.success,
    this.skipVideo = false,
  });

  final String? storyPassUpdateTicketToken;
  final String? storyPassReadTicketToken;
  final StoryPass storyPass;
  final List<String> invites;
  final SkipPauseVote? skipPauseVote;
  final Map<String, StoryPassCharacter> storyPassCharacters;
  final StoryCurrentPass? currentPass;
  final ItemPassQuiz quizDataToSend;
  final int conditionTimer;
  final Map<String, bool> isOnlineUser;
  final bool loading;
  final bool isAutoStart;
  final bool isInQuota;
  final Story? story;
  final String? chosenAct;
  final List<StoryMode> modes;
  final bool isTestAudiosampleLinkedToItemPass;
  final String? storyId;
  final PlayerState refPlayerStatus;
  final PlayerState testPlayerStatus;
  final PlayerState highlightPlayerStatus;
  final RecorderState recorderStatus;
  final Duration audiosampleRefDuration;
  final bool isInteractiveVideo;
  final bool isVideoOnBackground;
  final bool isImageOnBackground;
  final Videosample? videosample;
  final String? videosampleFilePath;
  final VideoLoadingStatus status;
  final bool isback2Unmuted;
  final List<String> invitedUsers;
  final bool isFullRecording;
  final bool isNextScreen;
  final int semanticAnalysisPercent;
  final bool recordingAllowed;
  final RecorderError recorderError;
  final bool skipVideo;

  bool get isNotEmpty =>
      isTestAudiosampleLinkedToItemPass ||
      (quizDataToSend.quizId?.isNotEmpty ?? false) ||
      (quizDataToSend.quizText?.isNotEmpty ?? false);

  StoryState copyWith({
    String? storyPassUpdateTicketToken,
    String? storyPassReadTicketToken,
    StoryPass? storyPass,
    List<String>? invites,
    SkipPauseVote? skipPauseVote,
    bool? nullSkipPauseVote,
    Map<String, StoryPassCharacter>? storyPassCharacters,
    StoryCurrentPass? currentPass,
    ItemPassQuiz? quizDataToSend,
    int? conditionTimer,
    Map<String, bool>? isOnlineUser,
    bool? loading,
    bool? isAutoStart,
    bool? isInQuota,
    Story? story,
    String? chosenAct,
    List<StoryMode>? modes,
    bool? isTestAudiosampleLinkedToItemPass,
    String? storyId,
    PlayerState? refPlayerStatus,
    PlayerState? testPlayerStatus,
    PlayerState? highlightPlayerStatus,
    RecorderState? recorderStatus,
    Duration? audiosampleRefDuration,
    bool? isInteractiveVideo,
    bool? isVideoOnBackground,
    bool? isImageOnBackground,
    Videosample? videosample,
    String? videosampleFilePath,
    VideoLoadingStatus? status,
    bool? isback2Unmuted,
    bool? isFullRecording,
    bool? isNextScreen,
    List<String>? invitedUsers,
    int? semanticAnalysisPercent,
    bool? recordingAllowed,
    RecorderError? recorderError,
    bool? skipVideo,
  }) {
    return StoryState(
      storyPassUpdateTicketToken:
          storyPassUpdateTicketToken ?? this.storyPassUpdateTicketToken,
      storyPassReadTicketToken:
          storyPassReadTicketToken ?? this.storyPassReadTicketToken,
      storyPass: storyPass ?? this.storyPass,
      invites: invites ?? this.invites,
      skipPauseVote: nullSkipPauseVote ?? false
          ? null
          : skipPauseVote ?? this.skipPauseVote,
      storyPassCharacters: storyPassCharacters ?? this.storyPassCharacters,
      currentPass: currentPass ?? this.currentPass,
      quizDataToSend: quizDataToSend ?? this.quizDataToSend,
      conditionTimer: conditionTimer ?? this.conditionTimer,
      isOnlineUser: isOnlineUser ?? this.isOnlineUser,
      loading: loading ?? this.loading,
      isAutoStart: isAutoStart ?? this.isAutoStart,
      isInQuota: isInQuota ?? this.isInQuota,
      story: story ?? this.story,
      chosenAct: chosenAct ?? this.chosenAct,
      modes: modes ?? this.modes,
      isTestAudiosampleLinkedToItemPass: isTestAudiosampleLinkedToItemPass ??
          this.isTestAudiosampleLinkedToItemPass,
      storyId: storyId ?? this.storyId,
      refPlayerStatus: refPlayerStatus ?? this.refPlayerStatus,
      testPlayerStatus: testPlayerStatus ?? this.testPlayerStatus,
      highlightPlayerStatus:
          highlightPlayerStatus ?? this.highlightPlayerStatus,
      recorderStatus: recorderStatus ?? this.recorderStatus,
      audiosampleRefDuration:
          audiosampleRefDuration ?? this.audiosampleRefDuration,
      isInteractiveVideo: isInteractiveVideo ?? this.isInteractiveVideo,
      isVideoOnBackground: isVideoOnBackground ?? this.isVideoOnBackground,
      isImageOnBackground: isImageOnBackground ?? this.isImageOnBackground,
      videosample: videosample ?? this.videosample,
      videosampleFilePath: videosampleFilePath ?? this.videosampleFilePath,
      status: status ?? this.status,
      isback2Unmuted: isback2Unmuted ?? this.isback2Unmuted,
      invitedUsers: invitedUsers ?? this.invitedUsers,
      isFullRecording: isFullRecording ?? this.isFullRecording,
      isNextScreen: isNextScreen ?? this.isNextScreen,
      semanticAnalysisPercent:
          semanticAnalysisPercent ?? this.semanticAnalysisPercent,
      recordingAllowed: recordingAllowed ?? this.recordingAllowed,
      recorderError: recorderError ?? this.recorderError,
      skipVideo: skipVideo ?? this.skipVideo,
    );
  }

  @override
  List<Object?> get props => [
        storyPassUpdateTicketToken,
        storyPassReadTicketToken,
        storyPass,
        invites.length,
        skipPauseVote,
        storyPassCharacters,
        currentPass,
        quizDataToSend,
        conditionTimer,
        isOnlineUser,
        loading,
        isAutoStart,
        isInQuota,
        story,
        chosenAct,
        modes,
        isTestAudiosampleLinkedToItemPass,
        storyId,
        refPlayerStatus,
        testPlayerStatus,
        highlightPlayerStatus,
        recorderStatus,
        audiosampleRefDuration,
        isInteractiveVideo,
        isVideoOnBackground,
        isImageOnBackground,
        videosample,
        videosampleFilePath,
        status,
        isFullRecording,
        isNextScreen,
        isback2Unmuted,
        invitedUsers,
        semanticAnalysisPercent,
        recordingAllowed,
        recorderError,
        skipVideo,
      ];
}
