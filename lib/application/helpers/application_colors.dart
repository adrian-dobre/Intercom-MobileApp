import 'dart:ui';

import 'package:intercom/application/widgets/status.dart';

final Map<StatusList, Color> appStatusColorMap = {
  StatusList.disconnected: const Color.fromARGB(255, 255, 49, 46),
  StatusList.wait: const Color.fromARGB(255, 17, 75, 95),
  StatusList.ring: const Color.fromARGB(255, 26, 147, 111),
  StatusList.talk: const Color.fromARGB(255, 242, 175, 71),
  StatusList.listen: const Color.fromARGB(255, 68, 100, 173),
  StatusList.open: const Color.fromARGB(255, 19, 154, 67)
};
