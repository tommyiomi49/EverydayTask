import 'package:flutter/material.dart';
import 'models/user_model.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/home/main_navigation_screen.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';

class TaskTrackerApp extends StatefulWidget {
  const TaskTrackerApp({Key? key}) : super(key: key);

  @override
  State<TaskTrackerApp> createState() => _TaskTrackerAppState();
}

class _TaskTrackerAppState extends State<TaskTrackerApp> {
  bool _isLoading = true;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await NotificationService.instance.init();
    final user = await AuthService.instance.loadCurrentSession();
    setState(() {
      _currentUser = user;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskTracker: School Works Reminder',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: _isLoading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : (_currentUser != null
              ? MainNavigationScreen(currentUser: _currentUser!)
              : const WelcomeScreen()),
    );
  }
}

