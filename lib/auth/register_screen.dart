// lib/auth/register_screen.dart
import 'package:flutter/material.dart';
import './auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuthException uchun

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // Formani tekshirish
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Muvaffaqiyatli ro'yxatdan o'tishdan keyin avvalgi ekranga qaytish
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      // Firebase tomonidan yuzaga kelgan xatolarni ushlash
      String message;
      if (e.code == 'weak-password') {
        message = 'Parol juda zaif. Kamida 6 ta belgi kiriting.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Bu email manzil allaqachon roʻyxatdan oʻtgan.';
      } else if (e.code == 'invalid-email') {
        message = 'Notoʻgʻri email formatida kiritilgan.';
      } else {
        message = 'Roʻyxatdan oʻtishda xato: ${e.message}';
      }
      setState(() => _errorMessage = message);
    } catch (e) {
      // Boshqa har qanday xatolarni ushlash
      setState(() => _errorMessage = 'Kutilmagan xato: $e');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Roʻyxatdan Oʻtish')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Yangi Profil Yaratish',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // EMAIL FIELD
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Manzil',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Iltimos, email kiriting';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Notoʻgʻri email formati';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // PASSWORD FIELD
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Parol (kamida 6 belgi)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Parol kamida 6 ta belgidan iborat boʻlishi kerak';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // XATO XABARI
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // REGISTER BUTTON
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  )
                      : const Text(
                    'ROʻYXATDAN OʻTISH',
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                // LOGIN GA O'TISH
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Hisobingiz bormi? Kirish'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}