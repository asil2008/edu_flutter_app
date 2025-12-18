// lib/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import '/auth/auth_service.dart';
import '../admin/admin_add_course.dart'; // Admin paneliga o'tish uchun import

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthService orqali joriy foydalanuvchini olish
    final authService = AuthService();
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // Profil menyusini chaqirish
              _showProfileMenu(context, user);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Xush Kelibsiz Kartasi
            _welcomeCard(user?.email ?? 'Mehmon'),
            const SizedBox(height: 30),

            // 2. Davom Ettirilayotgan Kurs
            const Text(
              'Davom Ettirilayotgan Kurs',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _continueLearningCard(),

            const SizedBox(height: 30),

            // 3. Yangi Kurslar Tavsiyasi
            const Text(
              'Sizga Tavsiya Qilamiz',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _recommendedCourses(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- UI METODLAR VA FUNKSIYALAR ---

  void _showProfileMenu(BuildContext context, user) {
    // 🔑 ADMIN CHECK: Loyiha adminining email manzili
    const adminEmail = 'asilbekclear2008@gmail.com';
    final bool isAdmin = user?.email == adminEmail;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user?.displayName ?? user?.email ?? 'Foydalanuvchi Profil',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // 🔑 ADMIN PANELIGA O'TISH TUGMASI (Faqat admin bo'lsa ko'rinadi)
              if (isAdmin)
                Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.security, color: Colors.red),
                      title: const Text('Admin Panel', style: TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminAddCourse(), // Admin qo'shish ekraniga o'tish
                          ),
                        );
                      },
                    ),
                    const Divider(),
                  ],
                ),

              // Profilni tahrirlash
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Profilni Tahrirlash'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profil tahrirlash ekraniga oʻtish')),
                  );
                },
              ),

              // Chiqish tugmasi
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Chiqish', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  await AuthService().logout();
                  // 🚨 mounted tekshiruvisiz, to'g'ri naviqatsiya
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _welcomeCard(String userName) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.indigo, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.waving_hand, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Assalomu alaykum,',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  // Emailning birinchi qismini ko'rsatish
                  userName.split('@').first,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _continueLearningCard() {
    // Hozircha statik ma'lumot
    const progress = 0.65;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.arrow_right_alt, color: Colors.indigo.shade600),
              const SizedBox(width: 8),
              const Text(
                'Davom Ettirish',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'IELTS Speaking Masterclass - 5-Dars',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            color: Colors.indigo.shade400,
            backgroundColor: Colors.indigo.shade100,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${(progress * 100).toInt()}% tugallangan',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _recommendedCourses() {
    // Bu yerda Firestore dan eng yaxshi reytingli kurslarni chiqarish lozim.
    return const Column(
      children: [
        _CourseCard(
          title: 'Advanced Flutter UI/UX',
          category: 'Mobile Dev',
          rating: 4.9,
        ),
        _CourseCard(
          title: 'SAT General English',
          category: 'Education',
          rating: 4.7,
        ),
      ],
    );
  }
}

// Kurs kartasi uchun yordamchi widget
class _CourseCard extends StatelessWidget {
  final String title;
  final String category;
  final double rating;
  // final VoidCallback onTap; // Navigatsiya keyin qo'shiladi

  const _CourseCard({
    required this.title,
    required this.category,
    required this.rating,
    // required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kurs tafsilotlari ekraniga oʻtish')),
          );
        }, // Vaqtinchalik bosish funksiyasi
        contentPadding: const EdgeInsets.all(12),
        leading: Icon(
          Icons.menu_book,
          color: Theme.of(context).primaryColor,
          size: 40,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(
                  ' $rating',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}