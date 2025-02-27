import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';

class SpecificServerClient implements Client {
  const SpecificServerClient(this._base, this._origin);

  final Uri _base;
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
  }) {
    return _origin.delete(
      _updatedUri(url),
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  @override
  Future<Response> get(
    Uri url, {
    Map<String, String>? headers,
  }) {
    return _origin.get(
      _updatedUri(url),
      headers: headers,
    );
  }

  @override
  Future<Response> head(
    Uri url, {
    Map<String, String>? headers,
  }) {
    return _origin.head(
      _updatedUri(url),
      headers: headers,
    );
  }

  @override
  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _origin.patch(
      _updatedUri(url),
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  @override
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _origin.post(
      _updatedUri(url),
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  @override
  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _origin.put(
      _updatedUri(url),
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  @override
  Future<String> read(
    Uri url, {
    Map<String, String>? headers,
  }) {
    return _origin.read(
      _updatedUri(url),
      headers: headers,
    );
  }

  @override
  Future<Uint8List> readBytes(
    Uri url, {
    Map<String, String>? headers,
  }) {
    return _origin.readBytes(
      _updatedUri(url),
      headers: headers,
    );
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    switch (request.runtimeType) {
      case MultipartRequest:
        return _origin.send(
          MultipartRequest(request.method, _updatedUri(request.url))
            ..headers.addAll(request.headers)
            ..fields.addAll((request as MultipartRequest).fields)
            ..files.addAll(request.files),
        );
      case Request:
        return _origin.send(
          Request(request.method, _updatedUri(request.url))
            ..headers.addAll(request.headers)
            ..bodyBytes = (request as Request).bodyBytes,
        );
      case StreamedRequest:
        return _origin.send(
          StreamedRequest(request.method, _updatedUri(request.url))
            ..headers.addAll(request.headers),
        );
    }

    return _origin.send(request);
  }

  Uri _updatedUri(Uri url) {
    return Uri(
      fragment: url.fragment,
      host: _base.host,
      path: url.path,
      port: _base.port,
      query: url.query,
      scheme: _base.scheme,
      userInfo: url.userInfo,
    );
  }
}
