import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http_client;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:voccent/http/account_deleted_exception.dart';
import 'package:voccent/http/client_token.dart';
import 'package:voccent/http/invalid_token_exception.dart';
import 'package:voccent/http/username_is_taken_exception.dart';
import 'package:voccent/http/username_required_exception.dart';

// ignore: must_be_immutable
class UserToken extends Equatable implements ClientToken {
  UserToken(
    this.apiBaseUrl,
    this._firebaseToken,
    this._clientToken,
    this._storage,
  );

  static const storageKey = 'USER_TOKEN';
  static const clientId = 'VocMobClientV1';
  static const clientSecret = 'c9c2be0e-c91f-46df-8f35-4fcb75397838';

  final Uri apiBaseUrl;

  final SharedPreferences _storage;

  Map<String, dynamic> _userSettings = <String, dynamic>{};
  final String _firebaseToken;
  final ClientToken _clientToken;
  final _lock = Lock();

  @override
  Future<String> value() async => _lock.synchronized(_value);

  Future<String> _value() async {
    if (hasValue()) {
      if (isExpired()) {
        await refresh();
      }
      return _storage.getStringList(storageKey)![0];
    }

    await clear();

    final reqBody = Map<String, dynamic>.from(_userSettings);
    reqBody['GrantType'] = 'firebase';
    reqBody['FirebaseToken'] = _firebaseToken;

    final clientToken = await _clientToken.value();

    var response = await http_client.post(
      Uri.parse('$apiBaseUrl/oauth2/token'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $clientToken',
      },
      body: json.encode(reqBody),
    );

    await _log(response, '36250d8b: get user_token');

    if (response.statusCode == 401) {
      const message = 'Got 401. '
          'Clearing Client token and trying to get User token again...';
      log(message, name: 'HTTP_UserToken');
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.log('HTTP_UserToken $message');
      }

      await _clientToken.clear();
      final clientToken = await _clientToken.value();

      response = await http_client.post(
        Uri.parse('$apiBaseUrl/oauth2/token'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $clientToken',
        },
        body: json.encode(reqBody),
      );

      await _log(response, '87246fd3: requesting with new client_token');
    }

    if (json.decode(response.body) is Map<String, dynamic>) {
      final body = json.decode(response.body) as Map<String, dynamic>;

      if (body.containsKey('err')) {
        if (body['err'].toString().contains('error-00a7f4f7')) {
          throw UsernameIsTakenException();
        }

        throw InvalidTokenException(body['err'].toString());
      }

      final data = body['data'] as Map<String, dynamic>;

      if ((data['needusername'] as bool?) ?? false) {
        throw UsernameRequiredException();
      }

      if ((data['needconfirmrestore'] as bool?) ?? false) {
        throw AccountDeletedException();
      }

      try {
        await _storage.setStringList(storageKey, <String>[
          data['access_token'] as String,
          data['refresh_token'] as String,
          data['expire_at'] as String,
        ]);
        if (data['OrganizationID'] != null) {
          await _storage.setString(
            'OrganizationID',
            data['OrganizationID'] as String,
          );
        } else {
          await _storage.setString(
            'OrganizationID',
            '',
          );
        }

        if (data['RoleIsSystem'] != null) {
          await _storage.setBool(
            'RoleIsSystem',
            data['RoleIsSystem'] as bool,
          );
        } else {
          await _storage.setBool(
            'RoleIsSystem',
            false,
          );
        }
      } catch (_) {
        await clear();
        rethrow;
      }

      return _storage.getStringList(storageKey)![0];
    }

    if (response.statusCode != 200) {
      throw InvalidTokenException(response.reasonPhrase);
    }

    throw InvalidTokenException(response.body);
  }

  Future<void> _log(Response response, String operation) async {
    final message = '`$operation`: `${response.statusCode}` `${response.body}`';

    log(message, name: 'HTTP_UserToken');
    if (!kIsWeb) {
      await FirebaseCrashlytics.instance.log('HTTP_UserToken $message');
    }
  }

  // ignore: avoid_setters_without_getters
  set newUserSettings(Map<String, dynamic> settings) {
    _userSettings = settings;
  }

  @override
  bool hasValue() => _storage.containsKey(storageKey);

  @override
  bool isExpired() => DateTime.parse(
        _storage.getStringList(storageKey)![2],
      ).isBefore(DateTime.now().add(const Duration(minutes: 1)));

  @override
  Future<void> clear() => _storage.remove(storageKey);

  @override
  Future<void> refresh() async {
    final clientToken = await _clientToken.value();

    final response = await http_client.post(
      Uri.parse('$apiBaseUrl/oauth2/token'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $clientToken',
      },
      body: json.encode(<String, String>{
        'GrantType': 'refresh_token',
        'ClientId': clientId,
        'ClientSecret': clientSecret,
        'RefreshToken': _storage.getStringList(storageKey)![1],
      }),
    );

    await _log(response, 'e0c26115: refresh_token');

    final body = json.decode(response.body) as Map<String, dynamic>;

    if (body.containsKey('err')) {
      await clear();
      throw InvalidTokenException(body['err'].toString());
    }

    if (response.statusCode != 200) {
      await clear();
      throw InvalidTokenException(response.reasonPhrase);
    }

    final data = body['data'] as Map<String, dynamic>;

    try {
      await _storage.setStringList(storageKey, <String>[
        data['access_token'] as String,
        data['refresh_token'] as String,
        data['expire_at'] as String,
      ]);
      if (data['OrganizationID'] != null) {
        await _storage.setString(
          'OrganizationID',
          data['OrganizationID'] as String,
        );
      } else {
        await _storage.setString(
          'OrganizationID',
          '',
        );
      }
    } catch (_) {
      await clear();
      rethrow;
    }
  }

  @override
  List<Object> get props => [_firebaseToken];
}
