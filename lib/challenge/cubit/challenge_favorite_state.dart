part of 'challenge_favorite_cubit.dart';

enum ChallengeFavoriteStatus {
  initial,
  loading,
  ready,
  failed,
}

class ChallengeFavoriteState extends Equatable {
  const ChallengeFavoriteState({
    this.challengeFavoriteStatus = ChallengeFavoriteStatus.initial,
    this.isChallengeFavorite = false,
    this.challengeId,
  });

  final ChallengeFavoriteStatus challengeFavoriteStatus;
  final bool isChallengeFavorite;
  final String? challengeId;

  ChallengeFavoriteState copyWith({
    ChallengeFavoriteStatus? challengeFavoriteStatus,
    bool? isChallengeFavorite,
    String? challengeId,
  }) {
    return ChallengeFavoriteState(
      challengeFavoriteStatus:
          challengeFavoriteStatus ?? this.challengeFavoriteStatus,
      isChallengeFavorite: isChallengeFavorite ?? this.isChallengeFavorite,
      challengeId: challengeId ?? this.challengeId,
    );
  }

  @override
  List<Object?> get props => [
        challengeFavoriteStatus,
        isChallengeFavorite,
        challengeId,
      ];
}
