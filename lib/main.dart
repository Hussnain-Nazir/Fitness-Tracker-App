// main.dart
// App entry point. Initializes local notifications before runApp(), and
// sets Login as the initial screen.

import 'package:flutter/material.dart';
import 'services/notification_service.dart';
import 'screens/login_screen.dart';

const Color kPrimaryGreen = Color(0xFF00C896);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: kPrimaryGreen,
        scaffoldBackgroundColor: const Color(0xFFF6F8FB),
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
    );
  }
}
