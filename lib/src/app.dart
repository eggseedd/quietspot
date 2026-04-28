import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'features/auth/presentation/auth_wrapper.dart';

class QuietSpotApp extends StatelessWidget {
  const QuietSpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuietSpot',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}
