// main.dart
/*
 Lesson 28: [Custom Widget]
 - Creating a shortcut custom widget imported from another file for reusability.


  🧠 A] Concept:
     - This lesson teaches you how to create your own reusable widget in Flutter — known as a Custom Widget — and store it in a separate Dart file to keep your code clean, organized, and professional.

  🏗️ B] How It Works:

      1- Create a new Dart file (e.g. customcard.dart):

      - Inside it, define a class (like CustomListtile) that extends StatelessWidget.

      - Give it some parameters (name, email, date, imagename) and a constructor with required keywords.

      - Build a widget layout (e.g. a red Card with a ListTile and an image).

      - Import it in your main file (main.dart):

      - import 'package:first_app/customcard.dart';


      2- Use the custom widget as if it were a built-in Flutter widget:

        CustomListtile(
          name: "Ali",
          email: "ali@gmail.com",
          date: "25-6-2025",
          imagename: "assets/images/shadi.jpg",
        ),

      3- Flutter will automatically render your custom widget each time it’s called,
      4- giving you an easy way to repeat layouts without rewriting code.

    💡 C] Purpose and Benefits:
      1- Benefit	Description
       🧩 Reusability	You can use your custom widget anywhere in the app multiple times.
       🧹 Clean code	Keeps main.dart short and readable.
       🔧 Customization	Each instance can have different values (like name or image).
      🚀 Scalability	Makes your app easier to grow and maintain.
    
    🖼️ D] Result:
      You’ll see a list of cards, each containing:
        A circular image
        A name
        An email
        A date

*/

import 'package:flutter/material.dart';
import 'package:first_app/customcard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  // Scaffold Key
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  // Tab controller
  late final TabController tabController = TabController(
    length: 3,
    vsync: this,
  );

  // Selected bottom nav index
  int selectedIndex = 0;

  // Dummy page list
  final List<Widget> widgetList = [
    const Text(
      "page 1",
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),
    const Text(
      "page 2",
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),
    const Text(
      "page 3",
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),
  ];

  final List<String> imageNames = [
    'assets/images/img1.jpg',
    'assets/images/img2.jpg',
    'assets/images/img3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,

        // 1. Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.lightBlue,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.white,
          currentIndex: selectedIndex,
          onTap: (val) => setState(() => selectedIndex = val),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "User"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contact_page),
              label: "Contact",
            ),
          ],
        ),

        // 2. App Bar with TabBar
        appBar: AppBar(
          title: const Text("Custom Widget Example"),
          backgroundColor: Colors.lightBlue,
          bottom: TabBar(
            controller: tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 16),
            tabs: const [
              Tab(text: "PC"),
              Tab(icon: Icon(Icons.laptop), text: "Laptop"),
              Tab(icon: Icon(Icons.mobile_friendly), text: "Mobile"),
            ],
          ),
        ),

        // 3. Drawer (Left)
        drawer: Drawer(
          backgroundColor: Colors.green,
          width: 300,
          child: ListView(
            padding: const EdgeInsets.all(15),
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.asset(
                      "assets/images/shadi.jpg",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Expanded(
                    child: ListTile(
                      title: Text('Shadi'),
                      subtitle: Text('shadidev@gmail.com'),
                    ),
                  ),
                ],
              ),
              const Divider(),
              _drawerTile(Icons.home, 'Home Page'),
              _drawerTile(Icons.account_balance_rounded, 'Account Page'),
              _drawerTile(Icons.check_box, 'Order Page'),
              _drawerTile(Icons.help, 'About Us'),
              _drawerTile(Icons.phone_android_outlined, 'Contact'),
              _drawerTile(Icons.exit_to_app, 'Sign Out'),
            ],
          ),
        ),

        // 4. End Drawer (Right)
        endDrawer: const Drawer(),

        // 5. Floating Action Button
        floatingActionButton: FloatingActionButton(
          onPressed: () => print('FAB Pressed'),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        // 6. Body (Using Custom Widgets)
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: const [
              CustomListtile(
                name: "Sayed",
                email: "sayed@gmail.com",
                date: "25-6-2025",
                imagename: "assets/images/shadi.jpg",
              ),
              CustomListtile(
                name: "Ali",
                email: "ali@gmail.com",
                date: "25-2-2025",
                imagename: "assets/images/shadi.jpg",
              ),
              CustomListtile(
                name: "Mohamed",
                email: "mohamed@gmail.com",
                date: "25-8-2025",
                imagename: "assets/images/shadi.jpg",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Shortcut helper for drawer list tiles
  static ListTile _drawerTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {},
    );
  }
}
