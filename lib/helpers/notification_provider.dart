import 'package:flutter/material.dart';
import '../models/exploration.dart';

class NotificationProvider extends ChangeNotifier {
  List<Exploration> explorations;

  NotificationProvider(this.explorations);

  void addNotificationToExploration(
      String explorationId, int unreadNotifications) {
    final matchedExploration = explorations.firstWhere(
      (exp) => exp.id == explorationId,
      orElse: () => throw Exception('Failed to find exploration'),
    );
    matchedExploration.notificationCount = unreadNotifications;
    notifyListeners();
  }
}
