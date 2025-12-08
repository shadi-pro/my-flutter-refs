import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase (still needed if you use Firestore)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔎 Debug prints to confirm runtime config
  final app = Firebase.app();
  print('🔥 Firebase initialized with App ID: ${app.options.appId}');
  print('🔥 Project ID: ${app.options.projectId}');
  print('🔥 API Key: ${app.options.apiKey}');
  print('🔥 Storage Bucket: ${app.options.storageBucket}');

  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({super.key});

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      // ✅ Start directly at HomePage
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(onToggleTheme: _toggleTheme),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
