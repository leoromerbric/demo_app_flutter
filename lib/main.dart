import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(const MiWalletApp());
}

class MiWalletApp extends StatefulWidget {
  const MiWalletApp({super.key});

  @override
  State<MiWalletApp> createState() => _MiWalletAppState();
}

class _MiWalletAppState extends State<MiWalletApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light 
          ? ThemeMode.dark 
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Wallet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: LoginScreen(onThemeToggle: _toggleTheme),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.4),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}