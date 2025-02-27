part of 'rating_cubit.dart';

class RatingState extends Equatable {
  const RatingState({
    this.challengeId,
    this.loadingRating = true,
    this.rating,
  });

  final bool loadingRating;
  final String? challengeId;
  final double? rating;

  RatingState copyWith({
    bool? loadingRating,
    double? rating,
    String? challengeId,
  }) {
    return RatingState(
      loadingRating: loadingRating ?? this.loadingRating,
      rating: rating ?? this.rating,
      challengeId: challengeId ?? this.challengeId,
    );
  }

  @override
  List<Object?> get props => [
        loadingRating,
        rating,
        challengeId,
      ];
}
