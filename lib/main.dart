import 'package:flutter/material.dart';
import 'package:sortit/theme/app_theme.dart';
import 'package:sortit/screens/home/home_screen.dart';

void main() {
  runApp(const SortItApp());
}

class SortItApp extends StatelessWidget {
  const SortItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SortIt',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
