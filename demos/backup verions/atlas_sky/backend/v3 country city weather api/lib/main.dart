import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const AtlasSkyApp());
}

class AtlasSkyApp extends StatelessWidget {
  const AtlasSkyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AtlasSky',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
