// lib/admin/admin_add_course.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/firestore_service.dart';

class AdminAddCourse extends StatefulWidget {
  const AdminAddCourse({super.key});

  @override
  State<AdminAddCourse> createState() => _AdminAddCourseState();
}

class _AdminAddCourseState extends State<AdminAddCourse> {
  final _formKey = GlobalKey<FormState>();

  // Controllerlar: Kurs ma'lumotlari uchun
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _instructorController = TextEditingController();
  final _tagsController = TextEditingController();
  final _videoUrlController = TextEditingController(); // ✅ Yangi: Video URL uchun

  final _firestoreService = FirestoreService();
  bool isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _instructorController.dispose();
    _tagsController.dispose();
    _videoUrlController.dispose(); // Controller dispose qilinadi
    super.dispose();
  }

  // Kursni saqlash funksiyasi
  Future<void> _addCourse() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => isLoading = true);

    final title = _titleController.text.trim();
    final category = _categoryController.text.trim();
    final description = _descriptionController.text.trim();
    final instructor = _instructorController.text.trim();
    final videoUrl = _videoUrlController.text.trim(); // ✅ Video URL olinadi

    // Tags ni List<String> ga aylantirish
    final tags = _tagsController.text
        .split(',')
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toList();

    try {
      // addCourse chaqiruvi: Barcha majburiy va yangi parametrlarni berish
      await _firestoreService.addCourse(
        title: title,
        category: category,
        description: description,
        instructor: instructor,
        tags: tags,
        videoUrl: videoUrl, // ✅ Video URL saqlanadi
      );

      _clearFields();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Yangi kurs muvaffaqiyatli qoʻshildi!'),
            backgroundColor: Colors.green,
          ),
        );
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Kurs qoʻshishda xato yuz berdi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _clearFields() {
    _titleController.clear();
    _categoryController.clear();
    _descriptionController.clear();
    _instructorController.clear();
    _tagsController.clear();
    _videoUrlController.clear(); // ✅ Controller tozalash
  }

  // Validator funksiyasi: Bo'sh maydonni tekshirish
  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bu maydonni toʻldirish majburiy!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin • Kurs Qoʻshish'),
        backgroundColor: Colors.red.shade400,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Kurs Nomi
              _buildTextFormField(
                controller: _titleController,
                label: 'Kurs Nomi (Title)',
                validator: _requiredValidator,
              ),

              // 2. Kategoriya
              _buildTextFormField(
                controller: _categoryController,
                label: 'Kategoriya (IELTS, IT, SAT...)',
                validator: _requiredValidator,
              ),

              // 3. Ustoz
              _buildTextFormField(
                controller: _instructorController,
                label: 'Ustoz (Instructor) Nomi',
                validator: _requiredValidator,
              ),

              // 4. Tags
              _buildTextFormField(
                controller: _tagsController,
                label: 'Teglar (Tags)',
                hint: 'Vergul bilan ajratib yozing: English, Trading, Finance',
                validator: _requiredValidator,
              ),

              // 5. Video URL
              _buildTextFormField(
                controller: _videoUrlController,
                label: 'Kirish Video Manzili (YouTube URL)',
                keyboardType: TextInputType.url,
                validator: _requiredValidator,
              ),

              // 6. Tavsif
              _buildTextFormField(
                controller: _descriptionController,
                label: 'Tavsif (Description)',
                maxLines: 4,
                validator: _requiredValidator,
              ),

              const SizedBox(height: 24),

              // 7. ADD COURSE Button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Yordamchi vidjet: TextFormFieldni yaratish
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  // Yordamchi vidjet: Submit tugmasini yaratish
  Widget _buildSubmitButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : _addCourse,
        icon: isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Icon(Icons.add_box),
        label: Text(
          isLoading ? 'Qoʻshilmoqda...' : 'YANGI KURS QOʻSHISH',
          style: const TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}