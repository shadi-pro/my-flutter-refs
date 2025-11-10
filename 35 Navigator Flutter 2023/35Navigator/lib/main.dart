/*  
  35 [Navigator]   
  
  In this lesson, we learned how to navigate between multiple screens in Flutter using the Navigator widget and named routes.
  The goal is to understand how to move from one page to another (e.g., Home → About → Back) while keeping the code clean and modular.

🔹 A] Main Concepts Applied in the project :

    1- Navigator & Routes:

      - Defined routes inside MaterialApp using the routes property.
      - Used Navigator.pushNamed() to move forward between pages.
      - Used Navigator.pop() to return to the previous page.

    2- Multi-Page Structure:

      a- Created (4) separate Dart files:

        - {main.dart} → defines the routes and initializes the app.

        - {homepage.dart} → contains a list of custom widgets and a BottomNavigationBar.

        - {about.dart} → a simple information page navigated from the BottomNavigationBar.

        - {customcard.dart} → reusable card widget used across screens.

      b- BottomNavigationBar Integration:

        - Used onTap() with an index to trigger route navigation.

        - Displayed the selected page according to the tapped icon.

        - Highlighted the active icon using selectedItemColor.

      c - Custom Widgets Reusability:
        - Created a separate file for the custom card (CustomListtile) to demonstrate how to build, export, and reuse widgets across different screens.
  // -----------------------------------

🔹 B] Output Behavior :

   1- The app starts at the Home Page by default.

   2- Each card on the Home Page is displayed using the custom widget.

   3- The Bottom Navigation Bar allows switching between “Home” and “About” screens.

   4- The Navigator maintains the navigation stack, so pressing the back button returns to the previous screen.

🔹 C] Practical Skills Gained :

    1- How to use Navigator (push/pop) in real apps.

    2- How to structure multi-screen projects.

    3- How to integrate navigation with both buttons and BottomNavigationBar.

    4- How to organize code into multiple Dart files for clarity and scalability.

 */
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'about.dart';
import 'contact.dart';
// import 'customcard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigator Lesson',
      initialRoute: '/',
      routes: {
        '/': (context) => Homepage(),
        '/about': (context) => AboutPage(),
        '/contact': (context) => ContactPage(),
      },
    );
  }
}
