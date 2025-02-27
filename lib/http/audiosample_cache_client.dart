import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class AudiosampleCacheClient implements Client {
  const AudiosampleCacheClient(this._origin);

  final Client _origin;

  @override
  void close() => _origin.close();

  @override
  Future<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      _origin.delete(url, headers: headers, body: body, encoding: encoding);

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) async {
    if (url.path.startsWith('/api/v1/asset/object/audiosample/ref/')) {
      final audioSampleRefID = url.pathSegments.last;
      final directory = await getTemporaryDirectory();
      final audiosampleFile =
          File('${directory.path}/audiosample_${audioSampleRefID}_body');
      final headersFile =
          File('${directory.path}/audiosample_${audioSampleRefID}_headers');

      if (!audiosampleFile.existsSync() || !headersFile.existsSync()) {
        final response = await _origin.get(url, headers: headers);
        if (response.statusCode < 200 || response.statusCode >= 400) {
          return response;
        }
        final h = jsonEncode(response.headers);
        headersFile.writeAsStringSync(h, flush: true);
        audiosampleFile.writeAsBytesSync(response.bodyBytes, flush: true);
      }
      final h =
          jsonDecode(headersFile.readAsStringSync()) as Map<String, dynamic>;
      return Response.bytes(
        audiosampleFile.readAsBytesSync(),
        200,
        headers: h.map(
          (key, value) => MapEntry<String, String>(key, value as String),
        ),
      );
    } else {
      return _origin.get(url, headers: headers);
    }
  }

  @override
  Future<Response> head(
    Uri url, {
    Map<String, String>? headers,
  }) =>
      _origin.head(url, headers: headers);

  @override
  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      _origin.patch(url, headers: headers, body: body, encoding: encoding);

  @override
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      _origin.post(url, headers: headers, body: body, encoding: encoding);

  @override
  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      _origin.put(url, headers: headers, body: body, encoding: encoding);

  @override
  Future<String> read(
    Uri url, {
    Map<String, String>? headers,
  }) =>
      _origin.read(url, headers: headers);

  @override
  Future<Uint8List> readBytes(
    Uri url, {
    Map<String, String>? headers,
  }) =>
      _origin.readBytes(url, headers: headers);

  @override
  Future<StreamedResponse> send(BaseRequest request) => _origin.send(request);
}
