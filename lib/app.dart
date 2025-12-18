import 'package:flutter/material.dart';
import 'navigation/main_navigation.dart';
import 'auth/auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Education App',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),

      themeMode: ThemeMode.system,

      /// 🔑 ENG MUHIM JOY
      /// App ochilganda shu ekran chiqadi
      home: const AuthGate(),
    );
  }
}
