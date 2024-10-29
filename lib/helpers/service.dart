import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/exploration.dart';
import '../models/user.dart';

class Service {
  static String currentUserAuthToken = "";
  static const baseUrl = "http://MacBook-Air-6.local:3000/api";

  static Future<void> validateToken(
      String token, Function(UserData?) onComplete) async {
    const url = '$baseUrl/users/auth/login';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'AUTHORIZATION_TOKEN': token},
      );
      if (response.statusCode == 200) {
        var currentUser = parseUser(response.body);
        currentUserAuthToken =
            json.decode(response.body)['authentication_token'];
        onComplete(currentUser);
      } else {
        print("Token validation failed with status: ${response.toString()}");
        onComplete(null);
      }
    } catch (e) {
      print("Token validation failed with error: $e");
      onComplete(null);
    }
  }

  static Future<void> saveFCMToken(String fcmToken) async {
    const url = '$baseUrl/users/auth/save_fcm_token';
    try {
      await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'FCM_TOKEN': fcmToken,
        'Authorization': 'Bearer $currentUserAuthToken',
      });
    } catch (e) {
      print("Error when trying to save fcm token: $e");
    }
  }

  static Future<void> signOutInBackend() async {
    const url = '$baseUrl/users/auth/logout';
    try {
      final response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $currentUserAuthToken',
      });
      if (response.statusCode == 200) {
        currentUserAuthToken = "";
      }
    } catch (e) {
      print("Token validation failed with error: $e");
    }
  }

  static Future<List<Exploration>> fetchExplorations() async {
    const url = '$baseUrl/all_explorations';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentUserAuthToken',
        },
      );
      if (response.statusCode == 200) {
        return parseExplorations(response.body);
      } else {
        throw Exception('Failed to load explorations: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching explorations: $e");
      rethrow;
    }
  }

  static Future<void> createExploration(
      String text, List<String> sources, Function(bool) onComplete) async {
    const url = '$baseUrl/create_exploration';
    Map data = {
      'exploration': {'text': text, 'sources': sources}
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentUserAuthToken',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        onComplete(true);
      } else {
        onComplete(false);
        print("Request failed with status: ${response.statusCode}");
        throw Exception('Failed to create exploration: ${response.statusCode}');
      }
    } catch (e) {
      onComplete(false);
      print("Request error: $e");
      rethrow;
    }
  }

  static Future<void> updateProfile(String id, String city, String bio) async {
    String url = '$baseUrl/update_profile?id=$id';
    Map data = {
      'user': {'city': city, 'bio': bio}
    };
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentUserAuthToken',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
      } else {
        print('Failed to update profile. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      print('There was an error when updating the profile: $e');
      rethrow;
    }
  }

  static Future<void> updateExploration(String id, String text,
      List<String> sources, Function(bool) onComplete) async {
    String url = '$baseUrl/update_exploration?id=$id';
    Map data = {
      'exploration': {'text': text, 'sources': sources}
    };
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentUserAuthToken',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        onComplete(true);
      } else {
        onComplete(false);
        throw Exception('Failed to update exploration');
      }
    } catch (e) {
      onComplete(false);
      print('some error: $e');
    }
  }

  static Future<void> markAllNotificationsAsRead(
      Function(bool) onComplete) async {
    const url = '$baseUrl/mark_all_notifications_as_read';
    try {
      final response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $currentUserAuthToken',
      });
      if (response.statusCode == 204) {
        onComplete(true);
      } else {
        onComplete(false);
      }
    } catch (e) {
      onComplete(false);
      print("Request error: $e");
    }
  }

  static Future<void> deleteAccountInBackend() async {
    const url = '$baseUrl/users/auth/delete';
    try {
      final response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $currentUserAuthToken',
      });
      if (response.statusCode == 200) {
        currentUserAuthToken = "";
      }
    } catch (e) {
      print("Token validation failed with error: $e");
    }
  }
}
