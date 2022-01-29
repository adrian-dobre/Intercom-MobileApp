import 'dart:convert';

import 'package:intercom/domain/entities/user_profile.dart';
import 'package:intercom/infrastructure/repositories/base/base_repository.dart';

class UserRepository extends BaseRepository {
  UserRepository(
      {required String address,
      required String username,
      required String password})
      : super(address: address, username: username, password: password);

  Future<UserProfile> getProfile() {
    var url = Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        pathSegments: [uri.path, 'users', 'profile']);

    return get(url).then((response) {
      if (response.statusCode != 200) {
        throw Exception('Unexpected ${response.statusCode} API response');
      }
      return UserProfile.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    });
  }
}
