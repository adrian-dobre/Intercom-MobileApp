import 'package:flutter/material.dart';
import 'package:intercom/application/helpers/push_notifications.dart';
import 'package:intercom/application/mixins/error_handling.dart';
import 'package:intercom/application/pages/call_log.dart';
import 'package:intercom/application/pages/intercom.dart';
import 'package:intercom/application/pages/settings.dart';
import 'package:intercom/application/widgets/loading_indicator.dart';
import 'package:intercom/domain/entities/intercom_device.dart';
import 'package:intercom/infrastructure/repositories/repos.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'intercom_settings.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with ErrorHandling {
  String? username;
  String? password;
  String? webSocketServerAddress;
  String? webApiServerAddress;
  String? deviceId;
  IntercomDevice? device;
  List<IntercomDevice> devices = [];
  bool preferencesLoaded = false;
  String? notificationToken;
  Image image = const Image(
      image: AssetImage('assets/icon/icon.png'), width: 300, height: 300);

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      password = prefs.getString('password');
      webSocketServerAddress = prefs.getString('webSocketServerAddress');
      webApiServerAddress = prefs.getString('webApiServerAddress');
      deviceId = prefs.getString('deviceId');
      preferencesLoaded = true;
    });
    try {
      Repos.init(webApiServerAddress ??= '', webSocketServerAddress ??= '',
          username ??= '', password ??= '', notificationToken ??= '');
    } catch (exception) {
      showError(context, exception.toString());
    }

    if (deviceId != null && device == null) {
      await Repos.deviceRepository.getDevice(deviceId!).then((device) {
        setState(() {
          this.device = device;
        });
      }).catchError((error) {
        showError(context, error.toString());
      });
    }
  }

  void clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('password');
    prefs.remove('webSocketServerAddress');
    prefs.remove('webApiServerAddress');
    prefs.remove('deviceId');
    await loadPreferences();
  }

  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username!);
    prefs.setString('password', password!);
    prefs.setString('webSocketServerAddress', webSocketServerAddress!);
    prefs.setString('webApiServerAddress', webApiServerAddress!);
    if (deviceId != null && deviceId!.isNotEmpty) {
      prefs.setString('deviceId', deviceId!);
    }
    try {
      Repos.init(webApiServerAddress!, webSocketServerAddress!, username!,
          password!, notificationToken!);
    } catch (exception) {
      showError(context, exception.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    PushNotifications.setup().then((token) {
      notificationToken = token;
    }).catchError((error) {
      notificationToken = "";
      showError(context, error.toString());
    }).whenComplete(() => loadPreferences());
  }

  confirmReset(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget reset = TextButton(
      child: const Text("Reset"),
      onPressed: () {
        clearPreferences();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Reset Configuration"),
      content: const Text("Are you sure you want to reset the configuration?"),
      actions: [
        cancelButton,
        reset,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (preferencesLoaded) {
      if (deviceId == null) {
        return displaySettingsPage();
      }
    }
    if (device != null) {
      return displayIntercomPage(context);
    }
    return displayLoadingScreen();
  }

  SettingsPage displaySettingsPage() {
    return SettingsPage(
      webApiServerAddress: webApiServerAddress!,
      webSocketServerAddress: webSocketServerAddress!,
      username: username!,
      password: password!,
      onSave: getSettingsSaveHandler(null),
    );
  }

  Scaffold displayLoadingScreen() {
    return const Scaffold(
      body: Center(
          child:
              LoadingIndicator()), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  IntercomPage displayIntercomPage(BuildContext context) {
    return IntercomPage(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                  height: 150,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Text('Intercom',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 32))
                        ]),
                  )),
              ListTile(
                title: const Text('Call Log'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CallLogPage(intercomDevice: device!)),
                  );
                },
              ),
              ListTile(
                title: const Text('Intercom Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IntercomSettingsPage(
                              intercomDevice: device!,
                              onSave: (device) {
                                Repos.deviceRepository
                                    .updateDevice(device)
                                    .then((value) {
                                  setState(() {
                                    this.device = device;
                                  });
                                });
                              },
                            )),
                  );
                },
              ),
              ListTile(
                title: const Text('Configuration'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsPage(
                              webApiServerAddress: webApiServerAddress!,
                              webSocketServerAddress: webSocketServerAddress!,
                              username: username!,
                              password: password!,
                              onSave: getSettingsSaveHandler(() {
                                Navigator.pop(context);
                              }))));
                },
              ),
              ListTile(
                title: const Text('Reset Configuration'),
                onTap: () {
                  Navigator.pop(context);
                  confirmReset(context);
                },
              ),
            ],
          ),
        ),
        intercomDevice: device!);
  }

  getSettingsSaveHandler(Function? afterSave) {
    return (
        {required String webApiServerAddress,
        required String webSocketServerAddress,
        required String username,
        required String password}) async {
      setState(() {
        this.webApiServerAddress = webApiServerAddress;
        this.webSocketServerAddress = webSocketServerAddress;
        this.username = username;
        this.password = password;
      });
      await savePreferences();
      Repos.deviceRepository.getDevicesList().then((devices) {
        setState(() {
          device = devices.first;
          deviceId = devices.first.id;
        });
        savePreferences();
      }).catchError((error) {
        showError(context, error.toString());
      });
      if (afterSave != null) {
        afterSave();
      }
    };
  }
}
