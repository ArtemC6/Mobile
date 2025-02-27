// NOTE: we use CEFR scale from https://www.efset.org/english-score/
String levelToCEFR(int levelValue) {
  String levelLetter;

  if (levelValue >= 71) {
    levelLetter = 'Advanced';
  } else if (levelValue >= 61 && levelValue <= 70) {
    levelLetter = 'Advanced';
  } else if (levelValue >= 51 && levelValue <= 60) {
    levelLetter = 'Intermediate';
  } else if (levelValue >= 41 && levelValue <= 50) {
    levelLetter = 'Intermediate';
  } else if (levelValue >= 31 && levelValue <= 40) {
    levelLetter = 'Beginner';
  } else {
    levelLetter = 'Beginner';
  }
  return levelLetter;
}
