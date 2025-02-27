import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:voccent/http/client_token.dart';
import 'package:voccent/http/invalid_token_exception.dart';

class AuthenticatedClient implements Client {
  AuthenticatedClient(this._token, this._origin);

  final ClientToken _token;
  String? _userAgentCache;
  final Client _origin;

  Future<String> _userAgent() async {
    if (_userAgentCache != null) {
      return _userAgentCache!;
    }

    final platform = await PackageInfo.fromPlatform();

    if (kIsWeb) {
      return _userAgentCache = 'Voccent/${platform.version} '
          '(flutter-web) ${platform.buildNumber}';
    }

    String os;

    try {
      os = '(${Platform.operatingSystem}; ${Platform.operatingSystemVersion}) ';
    } catch (e) {
      os = '';
    }

    return _userAgentCache =
        'Voccent/${platform.version} $os${platform.buildNumber}${kDebugMode ? '+debug' : ''}';
  }

  @override
  void close() {
    return _origin.close();
  }

  @override
  Future<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool retryIf401 = true,
  }) async {
    final response = await _origin.delete(
      url,
      headers: (headers ?? {})
        ..addAll({
          HttpHeaders.authorizationHeader: 'Bearer ${await _token.value()}',
          HttpHeaders.userAgentHeader: await _userAgent(),
        }),
      body: body,
      encoding: encoding,
    );

    if (response.statusCode == 401) {
      if (retryIf401) {
        switch (_errCode(response.body)) {
          case 'ret-auth-user-expire':
          case 'ret-auth-client-expire':
            await _token.refresh();
            return delete(
              url,
              headers: headers,
              body: body,
              encoding: encoding,
              retryIf401: false,
            );
          case 'ret-auth-user':
          case 'ret-auth-client':
          default:
            await _token.clear();
            return delete(
              url,
              headers: headers,
              body: body,
              encoding: encoding,
              retryIf401: false,
            );
        }
      } else {
        throw InvalidTokenException(
          'Token updated successfully but server responded with 401 anyway',
        );
      }
    }

    return response;
  }

  @override
  Future<Response> get(
    Uri url, {
    Map<String, String>? headers,
    bool retryIf401 = true,
  }) async {
    final response = await _origin.get(
      url,
      headers: (headers ?? {})
        ..addAll({
          HttpHeaders.authorizationHeader: 'Bearer ${await _token.value()}',
          HttpHeaders.userAgentHeader: await _userAgent(),
        }),
    );

    if (response.statusCode == 401) {
      if (retryIf401) {
        switch (_errCode(response.body)) {
          case 'ret-auth-user-expire':
          case 'ret-auth-client-expire':
            await _token.refresh();
            return get(
              url,
              headers: headers,
              retryIf401: false,
            );
          case 'ret-auth-user':
          case 'ret-auth-client':
          default:
            await _token.clear();
            return get(
              url,
              headers: headers,
              retryIf401: false,
            );
        }
      } else {
        throw InvalidTokenException(
          'Token updated successfully but server responded with 401 anyway',
        );
      }
    }

    return response;
  }

  @override
  Future<Response> head(
    Uri url, {
    Map<String, String>? headers,
    bool retryIf401 = true,
  }) async {
    final response = await _origin.head(
      url,
      headers: (headers ?? {})
        ..addAll({
          HttpHeaders.authorizationHeader: 'Bearer ${await _token.value()}',
          HttpHeaders.userAgentHeader: await _userAgent(),
        }),
    );

    if (response.statusCode == 401) {
      if (retryIf401) {
        switch (_errCode(response.body)) {
          case 'ret-auth-user-expire':
          case 'ret-auth-client-expire':
            await _token.refresh();
            return head(
              url,
              headers: headers,
              retryIf401: false,
            );
          case 'ret-auth-user':
          case 'ret-auth-client':
          default:
            await _token.clear();
            return head(
              url,
              headers: headers,
              retryIf401: false,
            );
        }
      } else {
        throw InvalidTokenException(
          'Token updated successfully but server responded with 401 anyway',
        );
      }
    }

    return response;
  }

  @override
  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool retryIf401 = true,
  }) async {
    final response = await _origin.patch(
      url,
      headers: (headers ?? {})
        ..addAll({
          HttpHeaders.authorizationHeader: 'Bearer ${await _token.value()}',
          HttpHeaders.userAgentHeader: await _userAgent(),
        }),
      body: body,
      encoding: encoding,
    );

    if (response.statusCode == 401) {
      if (retryIf401) {
        switch (_errCode(response.body)) {
          case 'ret-auth-user-expire':
          case 'ret-auth-client-expire':
            await _token.refresh();
            return patch(
              url,
              headers: headers,
              body: body,
              encoding: encoding,
              retryIf401: false,
            );
          case 'ret-auth-user':
          case 'ret-auth-client':
          default:
            await _token.clear();
            return patch(
              url,
              headers: headers,
              body: body,
              encoding: encoding,
              retryIf401: false,
            );
        }
      } else {
        throw InvalidTokenException(
          'Token updated successfully but server responded with 401 anyway',
        );
      }
    }

    return response;
  }

  @override
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool retryIf401 = true,
  }) async {
    final response = await _origin.post(
      url,
      headers: (headers ?? {})
        ..addAll({
          HttpHeaders.authorizationHeader: 'Bearer ${await _token.value()}',
          HttpHeaders.userAgentHeader: await _userAgent(),
        }),
      body: body,
      encoding: encoding,
    );

    if (response.statusCode == 401) {
      if (retryIf401) {
        switch (_errCode(response.body)) {
          case 'ret-auth-user-expire':
          case 'ret-auth-client-expire':
            await _token.refresh();
            return post(
              url,
              headers: headers,
              body: body,
              encoding: encoding,
              retryIf401: false,
            );
          case 'ret-auth-user':
          case 'ret-auth-client':
          default:
            await _token.clear();
            return post(
              url,
              headers: headers,
              body: body,
              encoding: encoding,
              retryIf401: false,
            );
        }
      } else {
        throw InvalidTokenException(
          'Token updated successfully but server responded with 401 anyway',
        );
      }
    }

    return response;
  }

  @override
  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool retryIf401 = true,
  }) async {
    final response = await _origin.put(
      url,
      headers: (headers ?? {})
        ..addAll({
          HttpHeaders.authorizationHeader: 'Bearer ${await _token.value()}',
          HttpHeaders.userAgentHeader: await _userAgent(),
        }),
      body: body,
      encoding: encoding,
    );

    if (response.statusCode == 401) {
      if (retryIf401) {
        switch (_errCode(response.body)) {
          case 'ret-auth-user-expire':
          case 'ret-auth-client-expire':
            await _token.refresh();
            return put(
              url,
              headers: headers,
              body: body,
              encoding: encoding,
              retryIf401: false,
            );
          case 'ret-auth-user':
          case 'ret-auth-client':
          default:
            await _token.clear();
            return put(
              url,
              headers: headers,
              body: body,
              encoding: encoding,
              retryIf401: false,
            );
        }
      } else {
        throw InvalidTokenException(
          'Token updated successfully but server responded with 401 anyway',
        );
      }
    }

    return response;
  }

  @override
  Future<String> read(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    return _origin.read(
      url,
      headers: (headers ?? {})
        ..addAll({
          HttpHeaders.authorizationHeader: 'Bearer ${await _token.value()}',
          HttpHeaders.userAgentHeader: await _userAgent(),
        }),
    );
  }

  @override
  Future<Uint8List> readBytes(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    return _origin.readBytes(
      url,
      headers: (headers ?? {})
        ..addAll({
          HttpHeaders.authorizationHeader: 'Bearer ${await _token.value()}',
          HttpHeaders.userAgentHeader: await _userAgent(),
        }),
    );
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    request.headers.addAll({
      HttpHeaders.authorizationHeader: 'Bearer ${await _token.value()}',
      HttpHeaders.userAgentHeader: await _userAgent(),
    });

    return _origin.send(request);
  }

  String _errCode(String body) {
    final dynamic jsonBody = json.decode(body);

    final mapBody = jsonBody is Map<String, dynamic>
        ? jsonBody
        : json.decode(jsonBody as String) as Map<String, dynamic>;

    return mapBody['errcode'] as String;
  }
}
