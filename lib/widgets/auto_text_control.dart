class AutoTextControl {
  static bool shouldWrapWords(String text) {
    final regex = RegExp(r'[^\w\s]', unicode: true);
    return regex.hasMatch(text);
  }
}
