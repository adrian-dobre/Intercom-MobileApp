import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:intercom/application/widgets/status.dart';
import 'package:intercom/domain/entities/button_status.dart';
import 'package:intercom/domain/entities/intercom_message.dart';
import 'package:intercom/domain/entities/intercom_status.dart';
import 'package:intercom/infrastructure/repositories/base/base_repository.dart';
import 'package:web_socket_channel/io.dart';

class IntercomMessageRepository extends BaseRepository {
  late final String _notificationToken;
  IOWebSocketChannel? _channel;
  final List<IOWebSocketChannel> _channelsToClose = [];
  Function(IntercomStatus intercomStatus)? _onIntercomStatusChange;
  Function(ButtonStatus talkButtonStatus)? _onTalkButtonButtonStatusChange;
  Function(ButtonStatus openButtonStatus)? _onOpenButtonButtonStatusChange;
  Function(Exception exception)? _onException;
  Function()? _onConnected;
  int retries = 5;
  Timer? checkConnectedTimer;

  IntercomMessageRepository(
      {required String address,
      required String username,
      required String password,
      required String notificationToken})
      : super(address: address, username: username, password: password) {
    _notificationToken = notificationToken;
  }

  onIntercomStatusChange(
      Function(IntercomStatus intercomStatus) onIntercomStatusChange) {
    _onIntercomStatusChange = onIntercomStatusChange;
  }

  onTalkButtonButtonStatusChange(
      Function(ButtonStatus talkButtonStatus) onTalkButtonButtonStatusChange) {
    _onTalkButtonButtonStatusChange = onTalkButtonButtonStatusChange;
  }

  onOpenButtonButtonStatusChange(
      Function(ButtonStatus openButtonStatus) onOpenButtonButtonStatusChange) {
    _onOpenButtonButtonStatusChange = onOpenButtonButtonStatusChange;
  }

  onException(Function(Exception exception) onException) {
    _onException = onException;
  }

  onConnected(Function() onConnected) {
    _onConnected = onConnected;
  }

  openSocket() {
    if (_channel != null && _channel?.sink != null) {
      _channelsToClose.add(_channel!);
      _channel?.sink.close();
    }
    _channel = IOWebSocketChannel.connect(uri, headers: {
      'device-type': 'application',
      'notification-token': _notificationToken,
      'Authorization': 'Basic $basicAuth'
    });

    if (checkConnectedTimer != null) {
      checkConnectedTimer!.cancel();
    }

    checkConnectedTimer =
        Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_channel?.innerWebSocket?.readyState == WebSocket.open) {
        timer.cancel();
        if (_onConnected != null) {
          _onConnected!();
        }
      }
    });

    (IOWebSocketChannel channel) {
      channel.stream.listen((message) {
        IntercomMessage intercomMessage =
            IntercomMessage.fromJson(jsonDecode(message));
        switch (intercomMessage.type) {
          // intercom status
          case 2:
            {
              if (_onIntercomStatusChange != null) {
                _onIntercomStatusChange!(IntercomStatus(
                    intercomMessage.deviceId,
                    StatusList.values[intercomMessage.params[0] - 1]));
              }
            }
            break;
          // intercom button status
          case 5:
            {
              var buttonStatus = ButtonStatus(
                  intercomMessage.deviceId, intercomMessage.params[1] == 1);
              if (intercomMessage.params[0] == 1) {
                if (_onTalkButtonButtonStatusChange != null) {
                  _onTalkButtonButtonStatusChange!(buttonStatus);
                }
              } else if (intercomMessage.params[0] == 2) {
                if (_onOpenButtonButtonStatusChange != null) {
                  _onOpenButtonButtonStatusChange!(buttonStatus);
                }
              }
              break;
            }
        }
      }, onError: (error) {
        if (retries > 0) {
          retries--;
          scheduleReconnect();
        } else {
          if (_onException != null) {
            _onException!(error);
          }
          _channelsToClose.add(channel);
        }
      }, onDone: () {
        // do not reopen channels closed intentionally
        if (_channelsToClose.contains(channel)) {
          _channelsToClose.remove(channel);
        } else {
          scheduleReconnect();
        }
      });
    }(_channel!);
  }

  void scheduleReconnect() {
    Timer(const Duration(milliseconds: 200), () {
      openSocket();
    });
  }

  sendStatusChangeCommand(IntercomStatus intercomStatus) {
    _channel?.sink.add(jsonEncode(IntercomMessage.from(intercomStatus)));
  }
}
