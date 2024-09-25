import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/exploration.dart';
import '../models/user.dart';

class Service {
  static String currentUserAuthToken = "";

  static Future<void> validateToken(
      String token, Function(UserData?) onComplete) async {
    const url = 'http://192.168.1.86:3000/api/users/auth/login';
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
    const url = 'http://192.168.1.86:3000/api/users/auth/save_fcm_token';
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
    const url = 'http://192.168.1.86:3000/api/users/auth/logout';
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
    const url = 'http://192.168.1.86:3000/api/all_explorations';
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $currentUserAuthToken',
    });
    if (response.statusCode == 200) {
      return parseExplorations(response.body);
    } else {
      throw Exception('Failed to load explorations');
    }
  }

  static Future<void> createExploration(
      String text, List<String> sources, Function(bool) onComplete) async {
    const url = 'http://192.168.1.86:3000/api/create_exploration';
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
      }
    } catch (e) {
      onComplete(false);
      print("Request error: $e");
    }
  }

  static Future<void> updateProfile(String id, String city, String bio) async {
    String url = 'http://192.168.1.86:3000/api/update_profile?id=$id';
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
        print('maybe a loader to be hide here');
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print('There was an error when updating the profile: $e');
    }
  }

  static Future<void> updateExploration(String id, String text,
      List<String> sources, Function(bool) onComplete) async {
    String url = 'http://192.168.1.86:3000/api/update_exploration?id=$id';
    Map data = {
      'exploration': {'text': text, 'sources': sources}
    };
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
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
    const url = 'http://192.168.1.86:3000/api/mark_all_notifications_as_read';
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
    const url = 'http://192.168.1.86:3000/api/users/auth/delete';
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
