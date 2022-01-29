class IntercomDevice {
  final String id;
  final String userId;
  final int lastSeen;
  final int lastStatus;
  String name;
  bool autoResponse;
  int autoResponseDelay;
  int delayForAutoActions;
  bool reportButtonStatus;

  IntercomDevice(
      {required this.id,
      required this.userId,
      required this.name,
      required this.autoResponse,
      required this.autoResponseDelay,
      required this.delayForAutoActions,
      required this.reportButtonStatus,
      required this.lastSeen,
      required this.lastStatus});

  factory IntercomDevice.fromJson(Map<String, dynamic> json) {
    return IntercomDevice(
      id: json['id'],
      userId: json['userId'],
      name: json['name'] ??= "",
      autoResponse: json['autoResponse'],
      autoResponseDelay: json['autoResponseDelay'],
      delayForAutoActions: json['delayForAutoActions'],
      reportButtonStatus: json['reportButtonStatus'],
      lastSeen: json['lastSeen'],
      lastStatus: json['lastStatus'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'name': name,
        'autoResponse': autoResponse,
        'autoResponseDelay': autoResponseDelay,
        'delayForAutoActions': delayForAutoActions,
        'reportButtonStatus': reportButtonStatus,
        'lastSeen': lastSeen,
        'lastStatus': lastStatus
      };
}
