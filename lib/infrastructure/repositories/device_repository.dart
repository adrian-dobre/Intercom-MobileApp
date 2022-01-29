import 'dart:convert';

import 'package:intercom/domain/entities/call_log_entry.dart';
import 'package:intercom/domain/entities/intercom_device.dart';
import 'package:intercom/infrastructure/repositories/base/base_repository.dart';

class DeviceRepository extends BaseRepository {
  DeviceRepository(
      {required String address,
      required String username,
      required String password})
      : super(address: address, username: username, password: password);

  Future<List<IntercomDevice>> getDevicesList() {
    var url = Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        pathSegments: [uri.path, 'devices']);

    return get(url).then((response) {
      if (response.statusCode != 200) {
        throw Exception('Unexpected ${response.statusCode} API response');
      }
      return (jsonDecode(utf8.decode(response.bodyBytes)) as List).map((json) {
        return IntercomDevice.fromJson(json);
      }).toList();
    });
  }

  Future<IntercomDevice> getDevice(String deviceId) {
    var url = Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        pathSegments: [uri.path, 'devices', deviceId]);

    return get(url).then((response) {
      if (response.statusCode != 200) {
        throw Exception('Unexpected ${response.statusCode} API response');
      }
      return IntercomDevice.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    });
  }

  Future<IntercomDevice> updateDevice(IntercomDevice device) {
    var url = Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        pathSegments: [uri.path, 'devices', device.id]);

    return put(url, body: device.toJson()).then((response) {
      if (response.statusCode != 200) {
        throw Exception('Unexpected ${response.statusCode} API response');
      }
      return IntercomDevice.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    });
  }

  Future<List<CallLogEntry>> getDeviceCallLogList(String deviceId) {
    var url = Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        pathSegments: [uri.path, 'devices', deviceId, 'call-log']);

    return get(url).then((response) {
      if (response.statusCode != 200) {
        throw Exception('Unexpected ${response.statusCode} API response');
      }
      return (jsonDecode(utf8.decode(response.bodyBytes)) as List).map((json) {
        return CallLogEntry.fromJson(json);
      }).toList();
    });
  }
}
