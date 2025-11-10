/*
 Lessons applied in this application :  


Lesson: Using showDialog() in Flutter
🧩 Overview:

In this lesson, you’ll learn how to display pop-up dialogs in Flutter using the showDialog() function.
Dialogs are used to show important information, confirmations, or warnings without leaving the current page.

🧠 Key Concepts Covered:

Understanding how showDialog() works.

Using AlertDialog widget inside showDialog().

Handling OK and Cancel actions using Navigator.pop().

Showing different types of dialogs:

Information dialogs

Confirmation dialogs

Custom content dialogs

Integrating dialogs inside existing app structure with multiple pages and a drawer.

🧱 Project Files Overview:
File	Description
main.dart	App entry point and routes definition.
homepage.dart	Main page containing buttons to trigger different dialogs.
customcard.dart	Reusable card widget (unchanged from previous lessons).
about.dart	Secondary page for demonstration with navigation and dialog button.


How It Works:

showDialog() opens a modal dialog above the current screen.

The dialog remains active until you call:

Navigator.pop(context);


You can customize the dialog’s title, content, and buttons easily.

Using SnackBar after closing a dialog is great for user feedback.

🧭 Output Summary:

✅ Show info dialogs.
✅ Show confirm dialogs with multiple actions.
✅ Display SnackBars for feedback.
✅ Integrate dialogs in multi-page navigation.

    
 */
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'about.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dialog Demo',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const HomePage(),
      routes: {'/about': (context) => const AboutPage()},
    );
  }
}
