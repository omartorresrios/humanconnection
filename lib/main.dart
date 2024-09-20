import 'package:flutter/material.dart';
import 'package:humanconnection/views/root_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'helpers/flutter_channel_notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterChannelNotificationService(navigatorKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const RootView(),
    );
  }
}
