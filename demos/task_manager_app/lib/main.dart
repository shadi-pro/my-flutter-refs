// lib/
//  ├── main.dart
//  ├── models/
//  │    └── task.dart
//  ├── pages/
//  │    ├── home_page.dart
//  │    ├── add_task_page.dart
//  │    └── settings_page.dart
//  ├── widgets/
//  │    └── task_card.dart
//  └── utils/
//       └── app_colors.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
