import 'package:intercom/domain/entities/intercom_status.dart';

class IntercomMessage {
  int type;
  List<int> params;
  String deviceId;

  IntercomMessage(this.type, this.params, this.deviceId);

  factory IntercomMessage.fromJson(Map<String, dynamic> json) {
    return IntercomMessage(json['type'] as int, List<int>.from(json['params']),
        json['deviceId'] as String);
  }

  factory IntercomMessage.from(IntercomStatus intercomStatus) {
    return IntercomMessage(
        1, [intercomStatus.status.index + 1], intercomStatus.deviceId);
  }

  Map<String, dynamic> toJson() =>
      {'type': type, 'params': params, 'deviceId': deviceId};
}
