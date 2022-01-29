class CallLogEntry {
  String id;
  String deviceId;
  int time;
  String status;

  CallLogEntry(
      {required this.id,
      required this.deviceId,
      required this.time,
      required this.status});

  factory CallLogEntry.fromJson(Map<String, dynamic> json) {
    return CallLogEntry(
        id: json['id'],
        deviceId: json['deviceId'],
        time: json['time'],
        status: json['status']);
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'deviceId': deviceId, 'time': time, 'status': status};
}
