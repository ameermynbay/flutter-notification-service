import 'package:flutter/material.dart';
import 'reminder_screen.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter is initialized

  // Initialize the NotificationService
  NotificationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReminderScreen(),
    );
  }
}
