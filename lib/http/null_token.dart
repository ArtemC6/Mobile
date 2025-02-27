import 'dart:async';
import 'package:voccent/http/user_token.dart';

class NullToken implements UserToken {
  @override
  Future<void> clear() async {}

  @override
  bool isExpired() {
    return true;
  }

  @override
  bool hasValue() {
    return false;
  }

  @override
  Future<void> refresh() async {}

  @override
  Future<String> value() {
    throw UnimplementedError();
  }

  @override
  final Uri apiBaseUrl = Uri();

  @override
  // ignore: avoid_setters_without_getters
  set newUserSettings(Map<String, dynamic> settings) {}

  @override
  List<Object> get props => [];

  @override
  bool? get stringify => false;
}
