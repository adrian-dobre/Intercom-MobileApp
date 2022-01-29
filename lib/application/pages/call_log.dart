import 'package:flutter/material.dart';
import 'package:intercom/application/mixins/error_handling.dart';
import 'package:intercom/application/widgets/loading_indicator.dart';
import 'package:intercom/domain/entities/call_log_entry.dart';
import 'package:intercom/domain/entities/intercom_device.dart';
import 'package:intercom/infrastructure/repositories/repos.dart';
import 'package:intl/intl.dart';

Map<String, IconData> callStatusToIconDataMap = {
  'RINGING': Icons.call_received,
  'MISSED': Icons.call_missed,
  'ANSWERED': Icons.call,
  'OPENED': Icons.lock_open
};

class CallLogPage extends StatefulWidget {
  const CallLogPage({Key? key, required this.intercomDevice}) : super(key: key);
  final IntercomDevice intercomDevice;

  @override
  State<StatefulWidget> createState() => _CallLogPageState();
}

class _CallLogPageState extends State<CallLogPage> with ErrorHandling {
  List<CallLogEntry> callLogEntriesList = [];
  DateFormat dateFormat = DateFormat("MMMM d, yyyy HH:mm:ss");
  bool loading = true;

  @override
  void initState() {
    super.initState();
    Repos.deviceRepository
        .getDeviceCallLogList(widget.intercomDevice.id)
        .then((value) {
      setState(() {
        callLogEntriesList = value;
      });
    }).catchError((error) {
      showError(context, error.toString());
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Call Log"),
      ),
      body: Center(
          child: loading
              ? const LoadingIndicator()
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: ListView(
                            children: callLogEntriesList
                                .map((entry) => Container(
                                      height: 50,
                                      width: double.maxFinite,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 236, 236, 236)))),
                                      child: Row(
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Icon(
                                                  callStatusToIconDataMap[
                                                      entry.status],
                                                  size: 32)),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                  dateFormat.format(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          entry.time)),
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Color.fromARGB(
                                                          255, 61, 61, 61))))
                                        ],
                                      ),
                                    ))
                                .toList(),
                          )),
                        ],
                      ))
                    ],
                  ),
                )),
    );
  }
}
