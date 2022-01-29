import 'package:flutter/material.dart';
import 'package:intercom/application/helpers/application_colors.dart';
import 'package:intercom/application/mixins/error_handling.dart';
import 'package:intercom/application/widgets/intercom_button.dart';
import 'package:intercom/application/widgets/intercom_button_state_indicator.dart';
import 'package:intercom/application/widgets/status.dart';
import 'package:intercom/domain/entities/intercom_device.dart';
import 'package:intercom/domain/entities/intercom_status.dart';
import 'package:intercom/infrastructure/repositories/repos.dart';

class IntercomPage extends StatefulWidget {
  const IntercomPage({Key? key, required this.intercomDevice, this.drawer})
      : super(key: key);

  final IntercomDevice intercomDevice;
  final Widget? drawer;

  @override
  State<IntercomPage> createState() => _IntercomPageState();
}

class _IntercomPageState extends State<IntercomPage>
    with WidgetsBindingObserver, ErrorHandling {
  StatusList status = StatusList.wait;
  bool talkButtonEnabled = false;
  bool openButtonEnabled = false;
  int reconnectRetries = 0;
  bool reconnectInProgress = false;

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        openSocketConnection();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    Repos.intercomMessageRepository.onIntercomStatusChange((intercomStatus) {
      if (intercomStatus.deviceId == widget.intercomDevice.id) {
        setState(() {
          status = intercomStatus.status;
        });
      }
    });
    Repos.intercomMessageRepository
        .onTalkButtonButtonStatusChange((talkButtonStatus) {
      if (talkButtonStatus.deviceId == widget.intercomDevice.id) {
        setState(() {
          talkButtonEnabled = talkButtonStatus.enabled;
        });
      }
    });
    Repos.intercomMessageRepository
        .onOpenButtonButtonStatusChange((openButtonStatus) {
      if (openButtonStatus.deviceId == widget.intercomDevice.id) {
        setState(() {
          openButtonEnabled = openButtonStatus.enabled;
        });
      }
    });

    Repos.intercomMessageRepository.onException((exception) {
      setState(() {
        showError(context, exception.toString());
        status = StatusList.disconnected;
      });
      reconnectInProgress = false;
      doReconnect();
    });

    Repos.intercomMessageRepository.onConnected(() {
      if (status == StatusList.disconnected) {
        setState(() {
          status = StatusList.wait;
        });
      }
      clearScheduledReconnects();
    });

    openSocketConnection();
  }

  void handleInteraction(StatusList status) {
    Repos.intercomMessageRepository.sendStatusChangeCommand(
        IntercomStatus(widget.intercomDevice.id, status));
  }

  @override
  Widget build(BuildContext context) {
    var actions = getActions();
    return Scaffold(
        drawer: widget.drawer,
        appBar: AppBar(
          title: Text("Intercom ${widget.intercomDevice.name}"),
        ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: <Widget>[
                  Stack(
                    children: [
                      Status(
                        status: status,
                        autoResponse: widget.intercomDevice.autoResponse,
                        autoResponseDelay:
                            widget.intercomDevice.autoResponseDelay,
                      ),
                      IntercomButtonStateIndicator(
                          talkButtonActive: talkButtonEnabled,
                          openButtonActive: openButtonEnabled)
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: (actions.length > 2 ? 20 : 60)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: actions,
                    ),
                  )
                ]))));
  }

  List<Widget> getActions() {
    List<Widget> actions = [];
    if (status == StatusList.disconnected) {
      actions.add(IntercomButton(
          buttonColor: appStatusColorMap[StatusList.disconnected]!,
          pressedButtonColor: appStatusColorMap[StatusList.wait]!,
          text: "Re-connect",
          onInteraction: (isActive) {
            if (isActive) {
              scheduleReconnect();
            }
          }));
    }
    actions.addAll([
      IntercomButton(
          buttonColor: appStatusColorMap[StatusList.listen]!,
          pressedButtonColor: appStatusColorMap[StatusList.talk]!,
          text: "Answer",
          onInteraction: (isActive) {
            if (isActive) {
              handleInteraction(StatusList.talk);
            } else {
              handleInteraction(StatusList.listen);
            }
          }),
      IntercomButton(
          buttonColor: appStatusColorMap[StatusList.wait]!,
          pressedButtonColor: appStatusColorMap[StatusList.open]!,
          text: "Open",
          onInteraction: (isActive) {
            if (isActive) {
              handleInteraction(StatusList.open);
            } else {
              handleInteraction(StatusList.wait);
            }
          })
    ]);

    return actions;
  }

  void scheduleReconnect() {
    reconnectRetries++;
    doReconnect();
  }

  void clearScheduledReconnects() {
    reconnectRetries = 0;
    reconnectInProgress = false;
  }

  void doReconnect() {
    if (status == StatusList.disconnected && reconnectRetries > 0) {
      if (!reconnectInProgress) {
        reconnectInProgress = true;
        reconnectRetries--;
        openSocketConnection();
      }
    }
  }

  void openSocketConnection() {
    try {
      Repos.intercomMessageRepository.openSocket();
    } catch (exception) {
      showError(context, exception.toString());
      if (status != StatusList.disconnected) {
        status = StatusList.disconnected;
      }
    }
  }
}
