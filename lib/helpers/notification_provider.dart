import 'package:flutter/material.dart';
import 'package:humanconnection/helpers/service.dart';
import '../models/exploration.dart';

class NotificationProvider extends ChangeNotifier {
  List<ExplorationWithSimilar> explorationsWithSimilar;

  NotificationProvider(this.explorationsWithSimilar);

  Future<void> addNotificationToExploration(
      String explorationId, int unreadNotifications) async {
    final matchedExplorationWithSimilar = explorationsWithSimilar.firstWhere(
      (exp) => exp.exploration.id == explorationId,
      orElse: () => throw Exception('Failed to find exploration'),
    );
    matchedExplorationWithSimilar.exploration =
        matchedExplorationWithSimilar.exploration.copyWith(
      notificationCount: unreadNotifications,
    );
    try {
      final similarExplorations =
          await Service.fetchSimilarExplorationsFor(explorationId);
      matchedExplorationWithSimilar.similarExplorations = similarExplorations;
    } catch (e) {
      print('Error fetching similar explorations: $e');
      matchedExplorationWithSimilar.similarExplorations = [];
    }
    notifyListeners();
  }
}
