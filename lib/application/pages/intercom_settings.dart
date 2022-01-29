import 'package:flutter/material.dart';
import 'package:intercom/domain/entities/intercom_device.dart';

class IntercomSettingsPage extends StatefulWidget {
  const IntercomSettingsPage(
      {Key? key, required this.intercomDevice, required this.onSave})
      : super(key: key);

  final IntercomDevice intercomDevice;
  final void Function(IntercomDevice) onSave;

  @override
  State<StatefulWidget> createState() => _IntercomSettingsPageState();
}

class _IntercomSettingsPageState extends State<IntercomSettingsPage> {
  late bool autoResponse;
  late bool reportButtonStatus;
  late int autoResponseDelay;
  late int delayForAutoActions;
  late String name;

  final _formKey = GlobalKey<FormState>();
  List<int> autoResponseDelayChoices = [1, 2, 3, 4, 5];
  List<int> delayForAutoActionsChoices = [100, 200, 400, 800, 1600, 3200];

  @override
  void initState() {
    super.initState();
    autoResponse = widget.intercomDevice.autoResponse;
    autoResponseDelay = widget.intercomDevice.autoResponseDelay;
    reportButtonStatus = widget.intercomDevice.reportButtonStatus;
    delayForAutoActions = widget.intercomDevice.delayForAutoActions;

    if (!autoResponseDelayChoices.contains(autoResponseDelay)) {
      autoResponseDelayChoices.add(autoResponseDelay);
      autoResponseDelayChoices.sort((a, b) => a.compareTo(b));
    }

    if (!delayForAutoActionsChoices.contains(delayForAutoActions)) {
      delayForAutoActionsChoices.add(delayForAutoActions);
      delayForAutoActionsChoices.sort((a, b) => a.compareTo(b));
    }

    name = widget.intercomDevice.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings ${widget.intercomDevice.name}"),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            TextFormField(
              autocorrect: false,
              initialValue: widget.intercomDevice.name,
              decoration: const InputDecoration(
                  label: Text('Name'), hintText: 'Ap. 101'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Field is required';
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  name = value!;
                });
              },
            ),
            Row(children: [
              const Icon(Icons.lock_open_rounded, size: 24),
              const Expanded(
                  child:
                      Text(' Auto Response', style: TextStyle(fontSize: 16))),
              Switch(
                  value: autoResponse,
                  onChanged: (value) {
                    setState(() {
                      autoResponse = value;
                    });
                  })
            ]),
            Row(children: [
              const Icon(Icons.lock_clock_outlined, size: 24),
              const Expanded(
                  child: Text(' Auto Response Delay ',
                      style: TextStyle(fontSize: 16))),
              DropdownButton(
                  value: autoResponseDelay,
                  onChanged: autoResponse
                      ? (value) {
                          setState(() {
                            autoResponseDelay = value as int;
                          });
                        }
                      : null,
                  items: <int>[0, 1, 2, 3, 4, 5]
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value sec'),
                    );
                  }).toList())
            ]),
            Row(children: [
              const Icon(Icons.lightbulb_outlined, size: 24),
              const Expanded(
                  child: Text(' Report Button Status',
                      style: TextStyle(fontSize: 16))),
              Switch(
                  value: reportButtonStatus,
                  onChanged: (value) {
                    setState(() {
                      reportButtonStatus = value;
                    });
                  })
            ]),
            Row(children: [
              const Icon(Icons.motion_photos_paused_outlined, size: 24),
              const Expanded(
                  child: Text(' Delay For Auto Actions',
                      style: TextStyle(fontSize: 16))),
              DropdownButton(
                  value: delayForAutoActions,
                  onChanged: autoResponse
                      ? (value) {
                          setState(() {
                            delayForAutoActions = value as int;
                          });
                        }
                      : null,
                  items: <int>[100, 200, 400, 800, 1600, 3200]
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value msec'),
                    );
                  }).toList())
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    var intercom = IntercomDevice(
                        id: widget.intercomDevice.id,
                        userId: widget.intercomDevice.userId,
                        name: name,
                        autoResponse: autoResponse,
                        autoResponseDelay: autoResponseDelay,
                        delayForAutoActions: delayForAutoActions,
                        reportButtonStatus: reportButtonStatus,
                        lastSeen: widget.intercomDevice.lastSeen,
                        lastStatus: widget.intercomDevice.lastStatus);
                    widget.onSave(intercom);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              )
            ]),
          ]),
        ),
      )),
    );
  }
}
