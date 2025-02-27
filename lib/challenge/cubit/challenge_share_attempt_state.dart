import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/challenge/cubit/models/challenge.dart';
import 'package:voccent/challenge/cubit/models/challenge_attempt/challenge_attempt.dart';
import 'package:voccent/challenge/cubit/models/challenge_attempt/shared_attempts.dart';
import 'package:voccent/generated/l10n.dart';

class ShareAttemptState {
  ShareAttemptState({
    required this.noShare,
    required this.shareWithAuthor,
    required this.shareWithAllUsers,
    required this.includeVoice,
    required this.isProgress,
    this.playingAudioSampleTstId,
    this.sharedAttempts,
    this.sharedAttempt,
    this.challengeUserTicketToken,
    this.myAttempt,
    this.challenge,
    this.testPlayerStatus = PlayerStatus.initial,
  }) {
    if (testPlayerStatus == PlayerStatus.downloading) {
      attemptText = S.current.genericDownloading;
    } else if (testPlayerStatus == PlayerStatus.failed) {
      attemptText = S.current.genericFailed1;
    } else {
      attemptText = S.current.genericRecord;
    }
  }

  final bool noShare;
  final bool shareWithAuthor;
  final bool shareWithAllUsers;
  final bool includeVoice;
  final bool isProgress;
  final String? playingAudioSampleTstId;
  final List<SharedAttempt>? sharedAttempts;
  final SharedAttempt? sharedAttempt;
  final String? challengeUserTicketToken;
  final ChallengeAttempt? myAttempt;
  final Challenge? challenge;
  final PlayerStatus testPlayerStatus;
  late final String attemptText;

  ShareAttemptState copyWith({
    bool? noShare,
    bool? shareWithAuthor,
    bool? shareWithAllUsers,
    bool? includeVoice,
    bool? isProgress,
    String? playingAudioSampleTstId,
    List<SharedAttempt>? sharedAttempts,
    SharedAttempt? sharedAttempt,
    String? challengeUserTicketToken,
    ChallengeAttempt? myAttempt,
    Challenge? challenge,
    PlayerStatus? testPlayerStatus,
  }) {
    return ShareAttemptState(
      noShare: noShare ?? this.noShare,
      shareWithAuthor: shareWithAuthor ?? this.shareWithAuthor,
      shareWithAllUsers: shareWithAllUsers ?? this.shareWithAllUsers,
      includeVoice: includeVoice ?? this.includeVoice,
      isProgress: isProgress ?? this.isProgress,
      playingAudioSampleTstId:
          playingAudioSampleTstId ?? this.playingAudioSampleTstId,
      sharedAttempts: sharedAttempts ?? this.sharedAttempts,
      sharedAttempt: sharedAttempt ?? this.sharedAttempt,
      challengeUserTicketToken:
          challengeUserTicketToken ?? this.challengeUserTicketToken,
      myAttempt: myAttempt ?? this.myAttempt,
      challenge: challenge ?? this.challenge,
      testPlayerStatus: testPlayerStatus ?? this.testPlayerStatus,
    );
  }

  List<Object?> get props => [
        sharedAttempts,
        noShare,
        shareWithAuthor,
        shareWithAllUsers,
        isProgress,
        playingAudioSampleTstId,
        sharedAttempts,
        sharedAttempt,
        challengeUserTicketToken,
        myAttempt,
        challenge,
        testPlayerStatus,
      ];
}
