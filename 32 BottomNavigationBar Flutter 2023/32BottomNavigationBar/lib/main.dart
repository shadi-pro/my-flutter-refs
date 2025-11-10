/*
   
  32- [BottomNavigationBar]   +  Tabbar part 2 contents  [current lesson]   

    🔹 Main Purpose

      This app demonstrates how to combine multiple navigation widgets in Flutter:

      A BottomNavigationBar to switch between main pages.

      A TabBar with TabBarView inside the Home page to navigate between subpages (PC, Laptop, Mobile).

    🧱 Main Structure
      1️⃣ BottomNavigationBar

        Located at the bottom of the app.

        Contains 4 main pages:

        🧑 User

        🏠 Home

        ⚙️ Settings

        📞 Contact

        When the user taps any icon, the selectedIndex changes, and the page updates dynamically.

      2️⃣ Home Page (Special Page)

        Contains a TabBar (with 3 tabs: PC, Laptop, Mobile).

        Each tab displays an image and label inside a TabBarView.

        Controlled by a TabController for smooth tab switching.

      3️⃣ AppBar

        Displays the main app title.

        When on the Home tab, the TabBar appears just below it.

        Uses a custom color theme (light blue and white indicators).

      4️⃣ Drawer (Left Menu)

        Contains a profile section (circular image + name + email).

        A list of navigation links (Home, Account, About, Logout, etc.).

        Demonstrates how to build structured Drawer UI.

      5️⃣ FloatingActionButton

        Positioned at the bottom-right corner.

        Prints a message to the console when pressed.

    🧠 Concepts Covered

      ✅ BottomNavigationBar setup and dynamic navigation using selectedIndex
      ✅ TabBar + TabBarView integration with a TabController
      ✅ Combining multiple navigation systems in a single app
      ✅ Use of Drawer for sidebar menus
      ✅ Handling of asset images
      ✅ Clean code organization using helper functions

    🌈 Visual Summary

      * Navigation Hierarchy:

      App
      ├── AppBar
      │    └── Title + (TabBar in Home only )
      │
      ├── Drawer
      │    └── Profile + Menu List
      │
      ├── Body
      │    └── (BottomNavigationBar pages)
      │         ├── User Page
      │         ├── Home Page
      │         │     └── TabBarView (PC / Laptop / Mobile images)
      │         ├── Settings Page
      │         └── Contact Page
      │
      └── BottomNavigationBar (4 items)

*/

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  // Scaffold key
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  // Tab controller for the upper TabBar
  late TabController tabController;

  // Selected index for the bottom navigation bar
  int selectedIndex = 0;

  // Widget list for bottom navigation pages
  late List<Widget> widgetList;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);

    // List of widgets for bottom navigation pages   [ to be called inside body of home screen ]
    widgetList = [
      const Center(
        child: Text(
          "User page 1",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
      // Home page → will include the TabBarView
      buildHomeTabBarView(),
      const Center(
        child: Text(
          "Settings page 3",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
      const Center(
        child: Text(
          "Contact page 4",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    ];
  }

  // Reusable widget for the Home screen only  with TabBar + TabBarView
  Widget buildHomeTabBarView() {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey,
          indicatorWeight: 5,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(icon: Icon(Icons.computer), text: "PC"),
            Tab(icon: Icon(Icons.laptop), text: "Laptop"),
            Tab(icon: Icon(Icons.phone_android), text: "Mobile"),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              buildTabImage('assets/images/pc.jpg', 'PC'),
              buildTabImage('assets/images/laptop.jpg', 'Laptop'),
              buildTabImage('assets/images/mobile.jpg', 'Mobile'),
            ],
          ),
        ),
      ],
    );
  }

  // Helper to build image tab content
  Widget buildTabImage(String path, String label) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(path, height: 200, width: 200, fit: BoxFit.cover),
          const SizedBox(height: 10),
          Text(
            '$label Page',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text("BottomNavigationBar + TabBar"),
          backgroundColor: Colors.lightBlue,
        ),
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
                  const SizedBox(width: 10),
                  const Expanded(
                    child: ListTile(
                      title: Text('Shadi'),
                      subtitle: Text('shadidev@gmail.com'),
                    ),
                  ),
                ],
              ),
              const Divider(),
              const ListTile(leading: Icon(Icons.home), title: Text('Home')),
              const ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Account'),
              ),
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('About Us'),
              ),
              const ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
              ),
            ],
          ),
        ),
        endDrawer: const Drawer(),
        body: Padding(
          padding: const EdgeInsets.all(10),
          // calling the indexed content of hte defined  [widgetList]  inside the body of the  home  screen
          child: widgetList[selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (val) => setState(() => selectedIndex = val),
          backgroundColor: Colors.lightBlue,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.white,
          selectedFontSize: 18,
          unselectedFontSize: 14,
          type: BottomNavigationBarType.fixed,
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('Floating action button pressed!');
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
