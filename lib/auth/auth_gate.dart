// lib/auth/auth_gate.dart
import 'package:flutter/material.dart';
import './auth_service.dart';
import '../navigation/main_navigation.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Yuklanish holati uchun splash ekran
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Agar foydalanuvchi tizimga kirgan bo'lsa
        if (snapshot.hasData && snapshot.data != null) {
          return const MainNavigation();
        }

        // Aks holda login ekranini ko'rsatamiz
        return const LoginScreen();
      },
    );
  }
}