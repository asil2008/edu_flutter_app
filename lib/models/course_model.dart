// lib/models/course_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String title;
  final String category;
  final double rating;
  final int ratingCount; // Qo'shildi
  final String description; // Qo'shildi
  final String instructor; // Ustoz nomi
  final List<String> tags; // Teglar (IT, IELTS kabi)

  Course({
    required this.id,
    required this.title,
    required this.category,
    required this.rating,
    required this.ratingCount,
    required this.description,
    required this.instructor,
    required this.tags,
  });

  factory Course.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Course(
      id: doc.id,
      title: data['title'] ?? '',
      category: data['category'] ?? 'General',
      rating: (data['rating'] is num) ? (data['rating'] as num).toDouble() : 0.0,
      ratingCount: (data['ratingCount'] is int) ? data['ratingCount'] : 0,
      description: data['description'] ?? '',
      instructor: data['instructor'] ?? 'Unknown',
      tags: List<String>.from(data['tags'] ?? []),
    );
  }
}