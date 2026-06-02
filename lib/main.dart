// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const TotoSportsApp());
}

class TotoSportsApp extends StatelessWidget {
  const TotoSportsApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return MaterialApp(
      title: 'Toto Sports',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF6C3BFF),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C3BFF),
          secondary: Color(0xFF00BFFF),
          surface: Color(0xFF1E293B),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: 'SF Pro Display', fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontFamily: 'SF Pro Display', fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontFamily: 'SF Pro Display', fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontFamily: 'SF Pro Text'),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
