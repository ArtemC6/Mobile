part of 'onboarding_cubit.dart';

class OnboardingState extends Equatable {
  const OnboardingState({
    this.username = '',
    this.languagesICan = const [],
    this.languagesIWant = const [],
  });

  final String username;
  final List<Language> languagesICan;
  final List<Language> languagesIWant;

  OnboardingState copyWith({
    String? errorMessage,
    String? username,
    List<Language>? languagesICan,
    List<Language>? languagesIWant,
  }) {
    return OnboardingState(
      username: username ?? this.username,
      languagesICan: languagesICan ?? this.languagesICan,
      languagesIWant: languagesIWant ?? this.languagesIWant,
    );
  }

  @override
  List<Object?> get props => [
        username,
        languagesICan.length,
        languagesIWant.length,
      ];
}
