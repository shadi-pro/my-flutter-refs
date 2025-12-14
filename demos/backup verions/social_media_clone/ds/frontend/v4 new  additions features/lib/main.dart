// app structure [social media clone ]

// lib/
//  ├─ main.dart
//  ├─ pages/
//  │   ├─ add_post_page.dart
//  │   ├─ feed_page.dart
//  │   ├─ login_page.dart
//  │   ├─ profile_page.dart
//  │   ├─ search_page.dart
//  │   ├─ settings_page.dart
//  │   ├─ signup_page.dart
//  │   └─ splash_page.dart
//  ├─ models/
//  │   ├─ post.dart
//  ├─ widgets/
//  │   ├─ post_card.dart
//  │   └─ profile_header.dart
//  ├─ core/
//  │   ├─ providers/
//  │       ├─ theme_provider.dart
//  │   └─ theme/
//  │       └─ app_colors.dart
//  │       └─ app_theme.dart
// ------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/feed_page.dart';
import 'pages/profile_page.dart';
import 'pages/add_post_page.dart';
import 'pages/search_page.dart';
import 'pages/settings_page.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const SocialApp(),
    ),
  );
}

class SocialApp extends StatelessWidget {
  const SocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Social Portfolio App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
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

  // Initialize pages in initState to avoid build context issues
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const FeedPage(),
      const SearchPage(),
      const AddPostPage(),
      const SettingsPage(),
      const ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(_selectedIndex),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          // Show theme toggle on all pages except Settings
          if (_selectedIndex != 3)
            IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                size: 24,
              ),
              onPressed: () {
                themeProvider.toggleTheme();
              },
              tooltip: themeProvider.isDarkMode
                  ? 'Switch to Light Mode'
                  : 'Switch to Dark Mode',
            ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 2
          ? null // Hide FAB on Add Post page (redundant)
          : FloatingActionButton(
              onPressed: () {
                // Jump to Add Post page
                _onItemTapped(2);
              },
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
              tooltip: 'Create New Post',
            ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Feed';
      case 1:
        return 'Search';
      case 2:
        return 'Create Post';
      case 3:
        return 'Settings';
      case 4:
        return 'Profile';
      default:
        return 'Social App';
    }
  }
}
