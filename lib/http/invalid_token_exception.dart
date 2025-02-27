class InvalidTokenException implements Exception {
  InvalidTokenException(this.message);

  final String? message;

  @override
  String toString() {
    return message ?? super.toString();
  }
}
