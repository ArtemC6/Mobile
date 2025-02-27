import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:voccent/http/server_exception.dart';
import 'package:voccent/http/visible_to_user_server_exception.dart';

class ErrorThrowingClient implements Client {
  const ErrorThrowingClient(this._origin);

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

    _throwError(response);

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

    _throwError(response);

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

    _throwError(response);

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

    _throwError(response);

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

    _throwError(response);

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

    _throwError(response);

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
  }) async {
    return _origin.readBytes(
      url,
      headers: headers,
    );
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    return _origin.send(request);
  }

  void _throwError(Response response) {
    if (response.headers[HttpHeaders.contentTypeHeader]
            ?.startsWith('text/plain') ??
        false) {
      final dynamic jsonBody = json.decode(response.body);

      final mapBody = jsonBody is Map<String, dynamic>
          ? jsonBody
          : json.decode(jsonBody as String) as Map<String, dynamic>;

      if (mapBody.containsKey('err')) {
        if (mapBody['errcode'] == 'ret-2000') {
          throw VisibleToUserServerException(mapBody['err'] as String);
        }

        throw ServerException(mapBody['err'] as String);
      }
    }

    if (response.statusCode >= 400) {
      throw ServerException(response.reasonPhrase ?? 'Error');
    }
  }
}
