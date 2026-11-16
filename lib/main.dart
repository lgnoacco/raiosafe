import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';

void main() {
  AuthService.instancia.iniciar();
  runApp(const RaioSafeApp());
}

class RaioSafeApp extends StatelessWidget {
  const RaioSafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RaioSafe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF2F3F7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF263238),
          primary: const Color(0xFF263238),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
