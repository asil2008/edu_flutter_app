// lib/courses/course_detail_screen.dart
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseID;

  // ✅ 1. 'const' xatosi tuzatildi: Konstruktor 'const' bo'lishi uchun bu maydon ham 'const' bo'lishi shart emas,
  // yoki vidjet konstruktoridan 'const' ni olib tashlash kerak.
  // Bu yerda 'const' ni konstruktordan olib tashlash qulayroq.
  final firestoreService = FirestoreService();

  // ✅ 2. 'const' xatosi tuzatildi: Konstruktordan 'const' olib tashlandi.
  // Endi 'firestoreService' to'g'ri initsializatsiya qilinadi.
  CourseDetailScreen({super.key, required this.courseID});

  // URL ni ochish funksiyasi
  void _launchUrl(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video manzilini ochishda xato yuz berdi.')),
        );
      }
    }
  }

  // Baho va Izoh qo'shish dialogi (Namuna)
  void _showRatingDialog(BuildContext context, Course course) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kursni Baholash'),
          content: Text('Siz "${course.title}" kursiga baho berish/izoh yozish qismidasiz.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Yopish'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kurs Detallari'),
        backgroundColor: Colors.indigo.shade700,
        centerTitle: true,
      ),
      // Kurs ma'lumotlarini StreamBuilder<Course> orqali yuklash
      body: StreamBuilder<Course>(
        stream: firestoreService.getCourseById(courseID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ma\'lumot yuklashda xato: ${snapshot.error.toString()}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Kurs ma\'lumotlari topilmadi.'));
          }

          final Course course = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(course.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Kategoriya: ${course.category}', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),

                const Divider(height: 32),

                // Baho va Ustoz qismi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Ustoz: ${course.instructor}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(
                              course.averageRating.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Tavsif
                const Text('Tavsif:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(course.description),

                const SizedBox(height: 20),

                // Teglar
                const Text('Teglar:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: course.tags.map((tag) => Chip(label: Text(tag))).toList(),
                ),

                const SizedBox(height: 30),

                // Video ko'rish tugmasi
                if (course.videoUrl.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchUrl(course.videoUrl, context),
                      icon: const Icon(Icons.play_circle_fill),
                      label: const Text('Kirish Videosini Ko\'rish'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Baholash tugmasi
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showRatingDialog(context, course),
                    child: Text('Baholash (${course.commentsCount} izoh)'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}