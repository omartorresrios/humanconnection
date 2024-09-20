import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/exploration.dart';
import '../views/exploration_details_view.dart';
import 'notification_service.dart';

class FlutterChannelNotificationService {
  GlobalKey<NavigatorState>? _navigatorKey;
  static const MethodChannel _channel =
      MethodChannel('com.example.humanconnection.notifications');

  FlutterChannelNotificationService(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<void> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onForegroundNotificationReceived":
        Map<String, dynamic> notificationData = Map.from(call.arguments);
        addNotificationToExploration(notificationData);
        break;
      case "onTappedNotificationReceived":
        Map<String, dynamic> notificationData = Map.from(call.arguments);
        var matchedExplorationId = notificationData["exploration_id"];
        try {
          matchedExplorationId =
              convertMatchedExplorationId(matchedExplorationId);
          final provider = NotificationService().provider;
          Exploration? exploration = provider.explorations.firstWhere(
            (exp) => exp.id == matchedExplorationId,
            orElse: () => throw Exception('Failed to find exploration'),
          );
          _navigatorKey?.currentState?.push(
            MaterialPageRoute(
              builder: (context) =>
                  ExplorationDetailsView(exploration: exploration),
            ),
          );
        } catch (e) {
          print("Error occurred: $e");
        }
        break;
      case "onSilentNotificationReceived":
        Map<String, dynamic> notificationData = Map.from(call.arguments);
        addNotificationToExploration(notificationData);
        break;
      default:
        throw MissingPluginException();
    }
  }

  void addNotificationToExploration(Map<String, dynamic> notificationData) {
    var matchedExplorationId = notificationData["exploration_id"];
    var badge = notificationData["aps"]["badge"];
    try {
      matchedExplorationId = convertMatchedExplorationId(matchedExplorationId);
      int badgeValue;
      if (badge is double) {
        badgeValue = badge.toInt();
      } else if (badge is int) {
        badgeValue = badge;
      } else if (badge is String) {
        badgeValue = int.parse(badge);
      } else {
        throw Exception("Unexpected type for badge: ${badge.runtimeType}");
      }
      NotificationService()
          .addNotificationToExploration(matchedExplorationId, badgeValue);
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  convertMatchedExplorationId(matchedExplorationId) {
    if (matchedExplorationId is double) {
      matchedExplorationId = matchedExplorationId.toString();
    } else if (matchedExplorationId is int) {
      matchedExplorationId = matchedExplorationId.toString();
    } else if (matchedExplorationId is! String) {
      throw Exception(
          "Unexpected type for exploration_id: ${matchedExplorationId.runtimeType}");
    }
    return matchedExplorationId;
  }
}
