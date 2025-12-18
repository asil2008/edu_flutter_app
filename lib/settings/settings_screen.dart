// lib/settings/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Sozlamalar holati (odatda Provider/Bloc orqali boshqariladi, hozircha state)
  bool _isDarkTheme = false;
  bool _vibrationOnTap = true;
  String _currentLanguage = 'Uzbek';

  @override
  Widget build(BuildContext context) {
    // Appning mavjud themeMode ni olish (MyApp da ThemeMode.system o'rnatilgan)
    final themeMode = Theme.of(context).brightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;
    _isDarkTheme = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sozlamalar'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme/Dark Mode
          _buildSettingsHeader('Dizayn & Koʻrinish'),
          SwitchListTile(
            title: const Text('Tungi rejim (Dark Mode)'),
            secondary: const Icon(Icons.dark_mode),
            value: _isDarkTheme,
            onChanged: (val) {
              setState(() {
                _isDarkTheme = val;
                // Aslida bu yerda ThemeProvider/Bloc orqali themeMode o'zgarishi kerak
                // Hozirgi kodda ThemeMode.system ishlatilgani uchun bu funksiya ishlamaydi
                // lekin UI holatini ko'rsatish uchun qoldirildi.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tungi rejim ${val ? 'yoqildi' : 'oʻchirildi'} (toʻliq ishlashi uchun Theme Provider kerak)')),
                );
              });
            },
          ),

          // Theme Colour (O'zgartirish qiyinroq, shuning uchun dummy funksiya)
          ListTile(
            title: const Text('Asosiy Rangni Oʻzgartirish'),
            leading: const Icon(Icons.color_lens),
            trailing: Container(width: 24, height: 24, decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Rang oʻzgartirish dialogi ochiladi')),
              );
            },
          ),

          const Divider(),

          // Til
          _buildSettingsHeader('Umumiy'),
          ListTile(
            title: const Text('Tilni Oʻzgartirish'),
            leading: const Icon(Icons.language),
            trailing: DropdownButton<String>(
              value: _currentLanguage,
              items: <String>['Uzbek', 'English', 'Russian']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _currentLanguage = newValue!;
                  // Tilni o'zgartirish logikasi...
                });
              },
            ),
          ),

          // Tebranish
          SwitchListTile(
            title: const Text('Bosganda Tebranish (Vibration)'),
            secondary: const Icon(Icons.vibration),
            value: _vibrationOnTap,
            onChanged: (val) {
              setState(() {
                _vibrationOnTap = val;
                // Tebranish funksiyasi logikasi...
              });
            },
          ),

          const Divider(),

          // Siyosat va Kompaniya
          _buildSettingsHeader('Qoʻshimcha Maʼlumotlar'),
          ListTile(
            title: const Text('Maxfiylik Siyosati'),
            leading: const Icon(Icons.privacy_tip),
            onTap: () { /* Siyosat sahifasiga o'tish */ },
          ),
          ListTile(
            title: const Text('Foydalanish Shartlari'),
            leading: const Icon(Icons.gavel),
            onTap: () { /* Shartlar sahifasiga o'tish */ },
          ),
          ListTile(
            title: const Text('Kompaniya (Men Haqimda)'),
            leading: const Icon(Icons.info_outline),
            onTap: () {
              // Dialog/Sahifada ma'lumot berish
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
          fontSize: 14,
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kompaniya Haqida'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Bu ilova men tomonidan (Sizning ismingiz) shaxsiy loyihasi sifatida yaratilgan. Maqsad: IT, IELTS, Trading kabi oʻrganilgan kurslarni ommaga taqdim etish.',
                  style: TextStyle(height: 1.5),
                ),
                SizedBox(height: 15),
                Text('Versiya: 1.0.0'),
                Text('Kontakt: [Sizning email/telefon raqamingiz]'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yopish'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}