// lib/auth/login_screen.dart
import 'package:flutter/material.dart';
import './auth_service.dart'; // To'g'ri import
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _authService = AuthService();

  bool loading = false;
  String? error;

  Future<void> _login() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      await _authService.login(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );
      // Kirish muvaffaqiyatli, AuthGate MainNavigation'ga yo'naltiradi.
    } on Exception catch (e) {
      // Firebase xatolarini foydalanuvchiga tushunarli qilish
      setState(() => error = e.toString().contains('[firebase_auth]')
          ? e.toString().split(']').last.trim()
          : e.toString());
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Icon(Icons.school_rounded, size: 80, color: Theme.of(context).primaryColor),
              const SizedBox(height: 16),
              const Text(
                'Oqishga Xush Kelibsiz!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // Email
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Password
              TextField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              // Error
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 13)),
                ),

              // Login Button
              ElevatedButton(
                onPressed: loading ? null : _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: loading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('KIRISH', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),

              // Forgot Password
              TextButton(
                onPressed: () async {
                  if (_email.text.isNotEmpty) {
                    await _authService.resetPassword(_email.text.trim());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Parolni tiklash havolasi emailga yuborildi.')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Iltimos, email manzilingizni kiriting.')),
                    );
                  }
                },
                child: const Text('Parolni unutdingizmi?', style: TextStyle(color: Colors.grey)),
              ),

              const Divider(height: 30),

              // Register Button
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Hisob Yaratish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}