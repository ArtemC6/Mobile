import 'dart:convert';

class VisibleToUserServerException implements Exception {
  VisibleToUserServerException(this.value);
  final String value;

  @override
  String toString() {
    try {
      final e = json.decode(value) as Map<String, dynamic>;
      return e['Err'] as String;
    } catch (err) {
      return value;
    }
  }
}
