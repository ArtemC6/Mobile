import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http_client;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:voccent/http/invalid_token_exception.dart';

class ClientToken {
  ClientToken(this._api, this._storage);

  static const storageKey = 'CLIENT_TOKEN';
  static const clientId = 'VocMobClientV1';
  static const clientSecret = 'c9c2be0e-c91f-46df-8f35-4fcb75397838';
  final Uri _api;

  final SharedPreferences _storage;
  final _lock = Lock();

  Future<String> value() async => _lock.synchronized(_value);

  Future<String> _value() async {
    if (hasValue()) {
      if (isExpired()) {
        await refresh();
      }

      return _storage.getStringList(storageKey)![0];
    }

    await clear();

    final response = await http_client.post(
      Uri.parse('$_api/oauth2/token_client'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader:
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
      },
      body: json.encode(<String, String>{
        'GrantType': 'client_credentials',
        'ClientId': clientId,
        'ClientSecret': clientSecret,
      }),
    );

    await _log(response);

    if (response.statusCode != 200) {
      throw InvalidTokenException(response.reasonPhrase);
    }

    final body = json.decode(response.body) as Map<String, dynamic>;

    if (body.containsKey('err')) {
      throw InvalidTokenException(body['err'].toString());
    }

    final data = body['data'] as Map<String, dynamic>;

    try {
      await _storage.setStringList(storageKey, <String>[
        data['access_token'] as String,
        data['refresh_token'] as String,
        data['expire_at'] as String,
      ]);
    } catch (_) {
      await clear();
      rethrow;
    }

    return _storage.getStringList(storageKey)![0];
  }

  bool hasValue() => _storage.containsKey(storageKey);

  bool isExpired() => DateTime.parse(
        _storage.getStringList(storageKey)![2],
      ).isBefore(DateTime.now().add(const Duration(minutes: 1)));

  Future<void> clear() => _storage.remove(storageKey);

  Future<void> refresh() async {
    final refreshToken = _storage.getStringList(storageKey)![1];

    await clear();

    final response = await http_client.post(
      Uri.parse('$_api/oauth2/token_client'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader:
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
      },
      body: json.encode(<String, String>{
        'GrantType': 'refresh_token',
        'ClientId': clientId,
        'ClientSecret': clientSecret,
        'RefreshToken': refreshToken,
      }),
    );

    await _log(response);

    final body = json.decode(response.body) as Map<String, dynamic>;

    if (body.containsKey('err')) {
      throw InvalidTokenException(body['err'].toString());
    }

    if (response.statusCode != 200) {
      throw InvalidTokenException(response.reasonPhrase);
    }

    final data = body['data'] as Map<String, dynamic>;

    try {
      await _storage.setStringList(storageKey, <String>[
        data['access_token'] as String,
        data['refresh_token'] as String,
        data['expire_at'] as String,
      ]);
    } catch (_) {
      await clear();
      rethrow;
    }
  }

  Future<void> _log(http_client.Response response) async {
    final message = '`${response.statusCode}` `${response.body}`';

    log(message, name: 'HTTP_ClientToken');
    if (!kIsWeb) {
      await FirebaseCrashlytics.instance.log('HTTP_ClientToken $message');
    }
  }
}
