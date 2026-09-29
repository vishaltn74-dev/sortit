import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sortit/services/revenuecat_service.dart';
import 'package:sortit/theme/app_theme.dart';
import 'package:sortit/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Google Mobile Ads SDK
  await MobileAds.instance.initialize();

  // Initialize RevenueCat
  await RevenueCatService.init();

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
