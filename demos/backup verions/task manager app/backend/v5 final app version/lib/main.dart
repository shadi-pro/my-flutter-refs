import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'pages/add_task_page.dart';
import 'pages/login_page.dart';
import 'pages/profile_page.dart'; // 👤 new profile page

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  ThemeMode _themeMode = ThemeMode.system; // 🌗 default: system

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
      title: 'Task Manager',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: AuthGate(onToggleTheme: _toggleTheme), // ✅ pass toggle down
      routes: {
        '/add': (context) => const AddTaskPage(),
        '/login': (context) => const LoginPage(),
        '/profile': (context) => const ProfilePage(), // 👤 profile route
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  final VoidCallback onToggleTheme;
  const AuthGate({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return HomePage(onToggleTheme: onToggleTheme); // ✅ pass toggle
        }
        return const LoginPage();
      },
    );
  }
}
