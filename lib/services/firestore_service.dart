// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// ==========================================================
// COURSE MODEL
// ==========================================================
class Course {
  final String id;
  final String title;
  final String category;
  final String description;
  final String instructor;
  final List<String> tags;
  final String videoUrl;
  final Timestamp createdAt;
  final bool isActive;
  final double averageRating;
  final int commentsCount;

  Course({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.instructor,
    required this.tags,
    required this.videoUrl,
    required this.createdAt,
    required this.isActive,
    required this.averageRating,
    required this.commentsCount,
  });

  // Firestore Hujjatidan Dart Obyektiga aylantirish (Mapping)
  factory Course.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Course(
      id: doc.id,
      title: data['title'] ?? 'Nomsiz Kurs',
      category: data['category'] ?? 'Boshqa',
      description: data['description'] ?? '',
      instructor: data['instructor'] ?? 'Noma\'lum Ustoz',
      tags: List<String>.from(data['tags'] ?? []),
      videoUrl: data['videoUrl'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      isActive: data['isActive'] ?? false,
      // Firestore'dan kelgan number turini xavfsiz double ga aylantirish
      averageRating: (data['averageRating'] is num)
          ? (data['averageRating'] as num).toDouble()
          : 0.0,
      commentsCount: data['commentsCount'] ?? 0,
    );
  }
}

// ==========================================================
// FIRESTORE SERVICE
// ==========================================================
class FirestoreService {
  // Singleton Pattern: Faylni bir joyda initsializatsiya qilish uchun qulay
  // private constructor
  // FirestoreService._privateConstructor();
  // static final FirestoreService _instance = FirestoreService._privateConstructor();
  // factory FirestoreService() { return _instance; }

  // Sizning Firestore konsolingizdagi kolleksiya nomi
  final CollectionReference _coursesCollection =
  FirebaseFirestore.instance.collection('asilbeklegendabaribirhisqil');

  CollectionReference _getCommentsCollection(String courseId) {
    return _coursesCollection.doc(courseId).collection('comments');
  }

  // --- 1. Yangi Kurs Qo'shish (CREATE) ---
  Future<void> addCourse({
    required String title,
    required String category,
    required String description,
    required String instructor,
    required List<String> tags,
    required String videoUrl,
  }) async {
    try {
      final courseData = {
        'title': title,
        'category': category,
        'description': description,
        'instructor': instructor,
        'tags': tags,
        'videoUrl': videoUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'averageRating': 0.0,
        'commentsCount': 0,
      };
      await _coursesCollection.add(courseData);
    } on FirebaseException catch (e) {
      throw Exception('Firebase Xatosi: Kurs qo\'shishda muammo: ${e.message}');
    }
  }

  // --- 2. Barcha kurslarni olish (READ Multiple) ---
  Stream<List<Course>> getCourses() {
    return _coursesCollection
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Course.fromFirestore(doc)).toList();
    }).handleError((error) {
      print("Kurslar ro'yxatini olishda xato: $error");
      return <Course>[];
    });
  }

  // --- 3. Kursni ID bo'yicha olish (READ Single) ---
  Stream<Course> getCourseById(String courseId) {
    return _coursesCollection.doc(courseId).snapshots().map((doc) {
      if (!doc.exists) {
        throw Exception("Kurs topilmadi: ID $courseId");
      }
      return Course.fromFirestore(doc);
    });
  }

  // --- 4. Baho va Izoh Qo'shish (UPDATE) ---
  Future<void> addCommentAndRate({
    required String courseId,
    required String userId,
    required int rating,
    required String comment,
    required String userName,
  }) async {
    final commentData = {
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'timestamp': FieldValue.serverTimestamp(),
    };

    final courseRef = _coursesCollection.doc(courseId);

    // 1. Izohni sub-kolleksiyaga qo'shish
    await _getCommentsCollection(courseId).add(commentData);

    // 2. O'rtacha bahoni tranzaksiya orqali yangilash (Xavfsiz hisoblash)
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final courseSnapshot = await transaction.get(courseRef);
      if (!courseSnapshot.exists) {
        throw Exception("Baho berish uchun kurs topilmadi!");
      }

      final currentCommentsCount = courseSnapshot.get('commentsCount') as int;
      final currentAverageRating = (courseSnapshot.get('averageRating') as num).toDouble();

      final newCommentsCount = currentCommentsCount + 1;
      final newTotalRating = (currentAverageRating * currentCommentsCount) + rating;
      final newAverageRating = newTotalRating / newCommentsCount;

      transaction.update(courseRef, {
        'averageRating': newAverageRating,
        'commentsCount': newCommentsCount,
      });
    });
  }
}