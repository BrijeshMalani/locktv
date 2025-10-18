import 'package:flutter/material.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const LockTVApp());
}

class LockTVApp extends StatelessWidget {
  const LockTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LockTV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF161B22),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF161B22),
          selectedItemColor: Color(0xFF1E88E5),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF21262D),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MainNavigation(),
    );
  }
}
