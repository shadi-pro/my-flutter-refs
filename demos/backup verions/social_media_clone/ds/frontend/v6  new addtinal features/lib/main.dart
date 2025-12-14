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
//  │   ├─ notification_item.dart
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
import 'pages/notifications_page.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/post_provider.dart'; // NEW

void main() {
  runApp(
    MultiProvider(
      // Use MultiProvider for multiple providers
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()), // NEW
      ],
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
  late PageController
  _pageController; // Add PageController for smooth animation

  // Initialize pages in initState
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const FeedPage(),
      const SearchPage(),
      const AddPostPage(),
      const NotificationsPage(),
      const ProfilePage(),
    ];
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); // Smooth navigation
  }

  void _navigateToAddPost() {
    // Smooth navigation to Add Post page
    setState(() {
      _selectedIndex = 2;
    });
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
          // Theme toggle - show on all pages
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
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
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
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 2
          ? null // Hide on Add Post page
          : FloatingActionButton(
              onPressed: _navigateToAddPost, // Fixed: Now works properly
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
        return 'Notifications';
      case 4:
        return 'Profile';
      default:
        return 'Social App';
    }
  }
}
