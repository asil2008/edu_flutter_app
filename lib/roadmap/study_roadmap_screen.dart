// lib/roadmap/study_roadmap_screen.dart
import 'package:flutter/material.dart';

class StudyRoadmapScreen extends StatefulWidget {
  const StudyRoadmapScreen({super.key});

  @override
  State<StudyRoadmapScreen> createState() => _StudyRoadmapScreenState();
}

class _StudyRoadmapScreenState extends State<StudyRoadmapScreen> {
  final _goalController = TextEditingController();

  // Joy egallash uchun dummy data
  final List<String> dailyGoals = [
    'Bugun 2 soat IELTS lugʻatini oʻrganish',
    'Trading kursining 3-modulini tugatish',
    'SAT sinovidan 10 ta test yechish',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oʻqish Yoʻl Xaritasi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _goalInputCard(),
            const SizedBox(height: 25),

            const Text(
              'Bugungi Maqsadlar',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Maqsadlar ro'yxati
            if (dailyGoals.isEmpty)
              const Text('Bugun uchun maqsadingiz yoʻq. Kiritish tugmasini bosing!'),
            ...dailyGoals.map((goal) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 1,
              child: CheckboxListTile(
                value: goal.length % 2 == 0, // Shartli bajarilganlik
                onChanged: (val) {
                  // Maqsadni bajarilgan deb belgilash logikasi
                },
                title: Text(goal),
                secondary: const Icon(Icons.star, color: Colors.blue),
              ),
            )).toList(),

            const SizedBox(height: 30),

            // Haftalik progress (Placeholder)
            const Text(
              'Haftalik Progress (7 kunda 4 kun oʻqilgan)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _weeklyProgress(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _goalInputCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).primaryColor, width: 1),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ambitsiyani Beligilash',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          SizedBox(height: 8),
          Text(
            'Kunning eng muhim oʻqish maqsadini belgilang. Kun oxirida uni yakunlang.',
            style: TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _weeklyProgress() {
    // Joy egallash uchun dummy data
    const List<bool> days = [true, true, false, true, false, false, false];
    const List<String> dayNames = ['Dush', 'Sesh', 'Chor', 'Pay', 'Jum', 'Shan', 'Yak'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        return Column(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: days[index] ? Colors.green : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: days[index]
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : const Icon(Icons.close, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 4),
            Text(dayNames[index], style: const TextStyle(fontSize: 12)),
          ],
        );
      }),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yangi Maqsad'),
          content: TextField(
            controller: _goalController,
            decoration: const InputDecoration(
              labelText: 'Maqsadni kiriting (masalan: 3-darsni tugatish)',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _goalController.clear();
                Navigator.pop(context);
              },
              child: const Text('Bekor Qilish'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_goalController.text.isNotEmpty) {
                  // Maqsadni Firestorega qo'shish logikasi
                  dailyGoals.add(_goalController.text.trim());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Maqsad qoʻshildi: ${_goalController.text}')),
                  );
                  _goalController.clear();
                  Navigator.pop(context);
                  setState(() {});
                }
              },
              child: const Text('Qoʻshish'),
            ),
          ],
        );
      },
    );
  }
}