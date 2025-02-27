import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class ErrorCatchingClient<T extends Object> implements Client {
  const ErrorCatchingClient(this._origin, {required this.callback});

  final Client _origin;
  final FutureOr<void> Function(T) callback;

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
    try {
      return await _origin.delete(
        url,
        headers: headers,
        body: body,
        encoding: encoding,
      );
    } on T catch (e) {
      await callback(e);
      rethrow;
    }
  }

  @override
  Future<Response> get(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    try {
      return await _origin.get(
        url,
        headers: headers,
      );
    } on T catch (e) {
      await callback(e);
      rethrow;
    }
  }

  @override
  Future<Response> head(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    try {
      return await _origin.head(
        url,
        headers: headers,
      );
    } on T catch (e) {
      await callback(e);
      rethrow;
    }
  }

  @override
  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    try {
      return await _origin.patch(
        url,
        headers: headers,
        body: body,
        encoding: encoding,
      );
    } on T catch (e) {
      await callback(e);
      rethrow;
    }
  }

  @override
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    try {
      return await _origin.post(
        url,
        headers: headers,
        body: body,
        encoding: encoding,
      );
    } on T catch (e) {
      await callback(e);
      rethrow;
    }
  }

  @override
  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    try {
      return await _origin.put(
        url,
        headers: headers,
        body: body,
        encoding: encoding,
      );
    } on T catch (e) {
      await callback(e);
      rethrow;
    }
  }

  @override
  Future<String> read(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    try {
      return _origin.read(
        url,
        headers: headers,
      );
    } on T catch (e) {
      await callback(e);
      rethrow;
    }
  }

  @override
  Future<Uint8List> readBytes(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    try {
      return _origin.readBytes(
        url,
        headers: headers,
      );
    } on T catch (e) {
      await callback(e);
      rethrow;
    }
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    try {
      return _origin.send(request);
    } on T catch (e) {
      await callback(e);
      rethrow;
    }
  }
}
