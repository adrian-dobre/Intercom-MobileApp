import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intercom/application/helpers/application_colors.dart';

enum StatusList { wait, ring, talk, listen, open, disconnected }

class DeviceUiConfig {
  DeviceUiConfig(this.iconList, this.label);

  List<IconData> iconList;
  String label;
}

Map<StatusList, DeviceUiConfig> statusToConfigMap = {
  StatusList.disconnected: DeviceUiConfig([Icons.cloud_off], 'Disconnected'),
  StatusList.wait: DeviceUiConfig([Icons.call_end], 'Waiting'),
  StatusList.ring: DeviceUiConfig(
      [Icons.notifications_none, Icons.notifications_active_outlined],
      'Ringing'),
  StatusList.talk: DeviceUiConfig([Icons.mic_none], 'Talk'),
  StatusList.listen: DeviceUiConfig([Icons.volume_up_outlined], 'Listen'),
  StatusList.open: DeviceUiConfig([
    Icons.lock_outlined,
    Icons.lock_outlined,
    Icons.lock_open,
    Icons.lock_open,
    Icons.lock_open,
    Icons.lock_open
  ], 'Open'),
};

class Status extends StatefulWidget {
  Status(
      {Key? key,
      required this.status,
      this.autoResponse,
      this.autoResponseDelay})
      : super(key: key);

  final StatusList status;
  bool? autoResponse = false;
  int? autoResponseDelay = 0;

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  IconData? icon;
  Timer? iconChangeTimer;

  @override
  void initState() {
    super.initState();
    icon = statusToConfigMap[widget.status]!.iconList[0];
  }

  @override
  void dispose() {
    super.dispose();
    if (iconChangeTimer != null) {
      iconChangeTimer!.cancel();
    }
  }

  @override
  void didUpdateWidget(covariant Status oldWidget) {
    super.didUpdateWidget(oldWidget);
    int iconsNo = statusToConfigMap[widget.status]!.iconList.length;
    icon = statusToConfigMap[widget.status]!.iconList[0];
    if (iconChangeTimer != null) {
      iconChangeTimer!.cancel();
    }

    if (iconsNo > 1) {
      iconChangeTimer =
          Timer.periodic(const Duration(milliseconds: 300), (timer) {
        int index = ((int.parse(timer.tick.toString()) - 1) %
            statusToConfigMap[widget.status]!.iconList.length);
        setState(() {
          icon = statusToConfigMap[widget.status]!.iconList[index];
        });
      });
    }
  }

  Color getAutoResponseColor() {
    return widget.autoResponse != null && widget.autoResponse!
        ? const Color.fromARGB(255, 2, 128, 144)
        : const Color.fromARGB(255, 210, 210, 210);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: 300,
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: appStatusColorMap[widget.status],
            borderRadius: const BorderRadius.all(Radius.circular(4.0))),
        child: Padding(
            padding: const EdgeInsets.all(60),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(width: 3, color: Colors.white),
                  shape: BoxShape.circle),
              child: Icon(icon, size: 100, color: Colors.white),
            )),
      ),
      Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(statusToConfigMap[widget.status]!.label),
            ),
          )),
      Positioned(
          bottom: 0,
          right: 0,
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.motion_photos_auto_outlined,
                          size: 16, color: getAutoResponseColor()),
                      Icon(Icons.lock_open,
                          size: 16, color: getAutoResponseColor()),
                      Text('${widget.autoResponseDelay ?? 0} sec',
                          style: TextStyle(color: getAutoResponseColor())),
                    ],
                  ),
                ),
              ))),
    ]);
  }
}
