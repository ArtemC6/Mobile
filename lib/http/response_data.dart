import 'dart:convert';

import 'package:http/http.dart';

extension ResponseExtension on Response {
  bool hasMapData() {
    return (json.decode(body) as Map<String, dynamic>)['data']
        is Map<String, dynamic>;
  }

  Map<String, dynamic> mapData() {
    return (json.decode(body) as Map<String, dynamic>)['data']
        as Map<String, dynamic>;
  }

  List<dynamic> listData() {
    final data = json.decode(body) as Map<String, dynamic>;

    if (data['data'] == null) {
      return <dynamic>[];
    } else {
      return data['data'] as List<dynamic>;
    }
  }

  List<dynamic> list() {
    return json.decode(body) as List<dynamic>;
  }

  bool boolData() {
    return (json.decode(body) as Map<String, dynamic>)['data'] as bool;
  }
}

extension FutureResponseExtension on Future<Response> {
  Future<Map<String, dynamic>> mapData() async {
    final response = await this;
    return response.mapData();
  }

  Future<List<dynamic>> listData() async {
    final response = await this;
    return response.listData();
  }

  Future<List<dynamic>> list() async {
    final response = await this;
    return response.list();
  }

  Future<bool> boolData() async {
    final response = await this;
    return response.boolData();
  }
}
