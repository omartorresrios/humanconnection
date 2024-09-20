import 'package:humanconnection/helpers/notification_provider.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  NotificationProvider? _provider;

  void setProvider(NotificationProvider provider) {
    _provider = provider;
  }

  NotificationProvider get provider {
    if (_provider == null) {
      throw Exception('NotificationProvider has not been initialized.');
    }
    return _provider!;
  }

  void addNotificationToExploration(
      String explorationId, int unreadNotifications) {
    if (_provider != null) {
      _provider!
          .addNotificationToExploration(explorationId, unreadNotifications);
    }
  }

  NotificationService._internal();
}
