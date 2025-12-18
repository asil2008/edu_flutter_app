// lib/navigation/main_navigation.dart
import 'package:flutter/material.dart';

// Screens
import '../dashboard/dashboard_screen.dart';
import '../courses/courses_screen.dart'; // To'g'ri joylashuv
import '../roadmap/study_roadmap_screen.dart';
import '../settings/settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = const [
      DashboardScreen(),
      CoursesScreen(),
      StudyRoadmapScreen(),
      SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo, // Dizayn rangiga moslandi
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Roadmap',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}