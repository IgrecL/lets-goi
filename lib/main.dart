import 'package:flutter/material.dart';
import 'package:letsgoi/screens/achievements.dart';
import 'package:letsgoi/screens/quizzes.dart';
import 'package:letsgoi/screens/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Let\'s Goi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    AchievementsScreen(),
    QuizzesScreen(),
    SettingsScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _children[_currentIndex],
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          backgroundColor: Color.fromARGB(255, 10, 10, 10),
          selectedItemColor: Colors.red[900], 
          unselectedItemColor: Colors.grey[600],
          items: [
            BottomNavigationBarItem(
              icon: Icon(_currentIndex == 0 ? Icons.emoji_events : Icons.emoji_events_outlined),
              label: 'Achievements',
            ),
            BottomNavigationBarItem(
              icon: Icon(_currentIndex == 1 ? Icons.indeterminate_check_box : Icons.indeterminate_check_box_outlined),
              label: 'Quizzes',
            ),
            BottomNavigationBarItem(
              icon: Icon(_currentIndex == 2 ? Icons.settings : Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
