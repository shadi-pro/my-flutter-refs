// app strucutre [social media clone ]

// lib/
//  ├─ main.dart
//  ├─ pages/
//  │   ├─ login_page.dart
//  │   ├─ signup_page.dart
//  │   ├─ feed_page.dart
//  │   ├─ profile_page.dart
//  │   ├─ add_post_page.dart
//  │   └─ splash_page.dart
//  ├─ models/
//  │   ├─ post.dart
//  ├─ widgets/
//  │   ├─ post_card.dart
//  │   └─ profile_header.dart

import 'package:flutter/material.dart';
import 'pages/feed_page.dart';
import 'pages/profile_page.dart';
import 'pages/add_post_page.dart';

void main() {
  runApp(const SocialApp());
}

class SocialApp extends StatelessWidget {
  const SocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    FeedPage(),
    Center(child: Text('Search (coming soon)')),
    AddPostPage(),
    Center(child: Text('Notifications (coming soon)')),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Post'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
