part of 'playlist_translation_cubit.dart';

class PlaylistSpellingState extends Equatable {
  const PlaylistSpellingState({
    this.originalPhrase = '',
    this.translation = '',
    this.showTranslatedPhrase = false,
  });

  final String originalPhrase;
  final String translation;
  final bool showTranslatedPhrase;

  PlaylistSpellingState copyWith({
    String? originalPhrase,
    String? translation,
    bool? showTranslatedPhrase,
  }) {
    return PlaylistSpellingState(
      originalPhrase: originalPhrase ?? this.originalPhrase,
      translation: translation ?? this.translation,
      showTranslatedPhrase: showTranslatedPhrase ?? this.showTranslatedPhrase,
    );
  }

  @override
  List<Object?> get props => [
        originalPhrase,
        translation,
        showTranslatedPhrase,
      ];
}
