/*   lesson 28 :  Flutter AppBar – including [ Complete Example with Actions, Menu & Navigation ] :
    -  🧩 Lesson Description (Brief):

          In this lesson, we explore how to build a fully functional AppBar in Flutter that combines multiple UI elements and interactions.
          The example includes a title, leading menu icon, action buttons (search, notifications), and a popup menu — all integrated with real-time feedback using SnackBars.

          Additionally, a BottomNavigationBar is added to demonstrate coordinated navigation and state updates between UI components.

          The code also fixes a common layout issue (RenderFlex overflowed) using the TextOverflow.ellipsis property to ensure a responsive, clean look on smaller screens.

          🧠 Key Concepts Covered:

          AppBar structure and customization

          Using leading, title, and actions properties effectively

          Handling user interactions with IconButton and PopupMenuButton

          Displaying feedback using ScaffoldMessenger and SnackBar

          Managing bottom navigation with stateful widgets (BottomNavigationBar)

          Preventing overflow errors with responsive text (TextOverflow.ellipsis)
            
 */

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  // ScaffoldMessenger Key for SnackBar
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Show snackbar message
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('You tapped on item #$index'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Flutter AppBar Demo',
            overflow: TextOverflow.ellipsis, // prevent overflow
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldMessengerKey.currentState?.showSnackBar(
                const SnackBar(content: Text('Menu clicked')),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _scaffoldMessengerKey.currentState?.showSnackBar(
                  const SnackBar(content: Text('Search clicked')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                _scaffoldMessengerKey.currentState?.showSnackBar(
                  const SnackBar(content: Text('Notifications clicked')),
                );
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                _scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBar(content: Text('$value selected')),
                );
              },
              itemBuilder: (BuildContext context) {
                return {'Profile', 'Settings', 'Logout'}
                    .map(
                      (String choice) => PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      ),
                    )
                    .toList();
              },
            ),
          ],
        ),
        body: Center(
          child: Text(
            'Selected index: $_selectedIndex',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
