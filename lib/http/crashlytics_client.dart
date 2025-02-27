import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class CrashlyticsClient implements Client {
  const CrashlyticsClient(this._origin);

  final Client _origin;

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
  }) async {
    final response = await _origin.delete(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );

    await _log(url, 'DELETE', headers, body, response);

    return response;
  }

  @override
  Future<Response> get(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    final response = await _origin.get(
      url,
      headers: headers,
    );

    await _log(url, 'GET', headers, null, response);

    return response;
  }

  @override
  Future<Response> head(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    final response = await _origin.head(
      url,
      headers: headers,
    );

    await _log(url, 'HEAD', headers, null, response);

    return response;
  }

  @override
  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await _origin.patch(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );

    await _log(url, 'PATCH', headers, body, response);

    return response;
  }

  @override
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await _origin.post(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );

    await _log(url, 'POST', headers, body, response);

    return response;
  }

  @override
  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await _origin.put(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );

    await _log(url, 'PUT', headers, body, response);

    return response;
  }

  @override
  Future<String> read(
    Uri url, {
    Map<String, String>? headers,
  }) {
    return _origin.read(
      url,
      headers: headers,
    );
  }

  @override
  Future<Uint8List> readBytes(
    Uri url, {
    Map<String, String>? headers,
  }) {
    return _origin.readBytes(
      url,
      headers: headers,
    );
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    return _origin.send(request);
  }

  Future<void> _log(
    Uri url,
    String method,
    Map<String, String>? headers,
    Object? body,
    Response response,
  ) async {
    final String resposnseBody;

    if (response.headers[HttpHeaders.contentTypeHeader]
            ?.startsWith('text/plain') ??
        false) {
      resposnseBody = '`${response.body}`';
    } else {
      final short =
          response.body.substring(0, math.min(response.body.length, 25));

      resposnseBody = '`$short`...';
    }

    final message = '${response.statusCode} $method `$url` '
        'request headers: `$headers` '
        'request body: `$body` '
        'response body: $resposnseBody';

    log(message, name: 'HTTP');
    if (!kIsWeb) {
      await FirebaseCrashlytics.instance.log('HTTP $message');
    }
  }
}
