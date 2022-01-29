import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class BaseRepository {
  @protected
  late final Uri uri;
  late final String _username;
  late final String _password;
  @protected
  late final String basicAuth;

  BaseRepository(
      {required String username,
      required String password,
      required String address}) {
    uri = Uri.parse(address);
    _username = username;
    _password = password;
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    basicAuth = stringToBase64.encode('$_username:$_password');
  }

  @protected
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    var _headers = headers ??= {};
    _headers['Authorization'] = 'Basic $basicAuth';
    return http.get(url, headers: _headers);
  }

  @protected
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Map<String, dynamic>? body}) {
    var _headers = headers ??= {};
    _headers['Authorization'] = 'Basic $basicAuth';

    String? encodedBody;
    if (body != null) {
      _headers['Content-Type'] = 'application/json';
      encodedBody = jsonEncode(body);
    }

    return http.put(url, headers: _headers, body: encodedBody);
  }
}
