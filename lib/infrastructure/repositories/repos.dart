import 'package:intercom/infrastructure/repositories/device_repository.dart';
import 'package:intercom/infrastructure/repositories/intercom_message_repository.dart';
import 'package:intercom/infrastructure/repositories/user_repository.dart';

class Repos {
  static late DeviceRepository deviceRepository;
  static late IntercomMessageRepository intercomMessageRepository;
  static late UserRepository userRepository;

  static init(String webAPIServerAddress, String webSocketServerAddress,
      String username, String password, String notificationToken) {
    deviceRepository = DeviceRepository(
        address: webAPIServerAddress, username: username, password: password);
    intercomMessageRepository = IntercomMessageRepository(
        address: webSocketServerAddress,
        username: username,
        password: password,
        notificationToken: notificationToken);
    if (webSocketServerAddress.isNotEmpty) {
      intercomMessageRepository.openSocket();
    }
    userRepository = UserRepository(
        address: webAPIServerAddress, username: username, password: password);
  }
}
