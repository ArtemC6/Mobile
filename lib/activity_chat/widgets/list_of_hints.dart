import 'dart:math';

import 'package:voccent/generated/l10n.dart';

class ListOfHints {
  static final List<String> hints = [
    S.current.genericHello,
    S.current.whatIsVoccent,
    S.current.howToLearnALanguageWithVoccent,
    S.current.languagesAvailable,
    S.current.howOftenIsTheContentUpdated,
    S.current.improvingPronunciation,
    S.current.accessingTeacherClassrooms,
    S.current.emotionAnalysis,
    S.current.benefitsOfPlaylists,
    S.current.theRoleOfStoriesAndChallenges,
    S.current.interactingWithUsers,
    S.current.interactingWithTeachers,
  ];

  static List<String> getRandomHints(int numberOfHints) {
    final random = Random();
    final randomHints = <String>[];

    final hintsCopy = List<String>.from(hints)
      ..remove(S.current.emotionAnalysis);
    randomHints.add(S.current.emotionAnalysis);

    for (var i = 0; i < numberOfHints - 1; i++) {
      if (hintsCopy.isNotEmpty) {
        final index = random.nextInt(hintsCopy.length);
        randomHints.add(hintsCopy[index]);

        hintsCopy.removeAt(index);
      }
    }
    return randomHints;
  }
}
