// lib/courses_screen.dart
import 'package:flutter/material.dart';
import '../services/firestore_service.dart'; // Course modelini va serviceni import qilish
import 'course_detail_screen.dart'; // Kurs detal ekranini import qilish

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcha Kurslar'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: StreamBuilder<List<Course>>( // ✅ Tip: List<Course>
        stream: firestoreService.getCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Xato yuz bersa, ekranda xabarni ko'rsatish
            return Center(child: Text('Ma\'lumot yuklashda xato: ${snapshot.error}'));
          }

          final List<Course> courses = snapshot.data ?? [];

          if (courses.isEmpty) {
            return const Center(
              child: Text('Hozircha aktiv kurslar mavjud emas.', style: TextStyle(fontSize: 16)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: ListTile(
                  title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${course.instructor} • ${course.category}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(course.averageRating.toStringAsFixed(1)),
                    ],
                  ),
                  onTap: () {
                    // Kurs ID sini detal ekraniga yuborish
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailScreen(courseID: course.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}