/*
 Lessons applied in this application :  
    
Lesson: Navigator + Pop + Snackbar + Profile Drawer Integration
🧩 Overview:

In this lesson, we’ll explore how to manage screen navigation in Flutter using the Navigator.pop() method to return to the previous screen instead of pushReplacement().
You’ll also learn how to use a Snackbar to display which navigation method was used, and how to enhance the Drawer with a profile picture, name, and email.

🧠 Key Concepts Covered:

Use of Navigator.pushNamed() to navigate to a new route.

Use of Navigator.pop(context) to return to the previous route.

Implementation of SnackBar to notify the user which navigation method was triggered.

Adding a custom Drawer with profile info using:

UserAccountsDrawerHeader()


Integration of a BottomNavigationBar to navigate between pages.

Creating a reusable CustomCard widget to display list items with images and text.

🧱 Project Files Overview:
File	Description
main.dart	App entry point, contains all route definitions.
homepage.dart	The main screen with Drawer, BottomNavigationBar, and SnackBars.
about.dart	Simple “About” page with a “Back” button using Navigator.pop().
contact.dart	“Contact” page with a “Back” button using Navigator.pop().
customcard.dart	Reusable widget for displaying custom list items as cards.
📱 App Flow:

User opens the HomePage.

From the Drawer or BottomNavigationBar, they navigate to either the About or Contact screen using Navigator.pushNamed().

A SnackBar appears showing the navigation method used (“Navigator.pushNamed() used”).

In the About or Contact page, the user taps the Back button.

The app returns to the HomePage using:

Navigator.pop(context);


Another SnackBar appears confirming that Navigator.pop() was used.

🧭 Final Output:

A well-structured, multi-page Flutter app featuring:

A Drawer with a profile photo, name, and email.

A BottomNavigationBar linked to navigation routes.

SnackBars for real-time navigation feedback.

Clean Navigator logic using pushNamed() and pop().

CustomCard widget for reusable UI elements.
    
 */

import 'package:flutter/material.dart';
import 'homepage.dart';
import 'about.dart';
import 'contact.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigator Pop Lesson (Full)',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/about': (context) => const AboutPage(),
        '/contact': (context) => const ContactPage(),
      },
    );
  }
}
