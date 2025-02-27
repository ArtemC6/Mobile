class ServerException implements Exception {
  ServerException(this.value);
  final String value;

  @override
  String toString() {
    return value;
  }
}
