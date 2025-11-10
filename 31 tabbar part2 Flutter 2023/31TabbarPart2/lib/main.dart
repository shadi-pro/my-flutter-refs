/*
 Lessons applied in this application :   
  
  30- [Tabbar]  - part 1 
    ✅ Creating (3) {Tab()} inside the [TabBar] within {AppBar}.
    ✅ Adding (3) children inside {TabBarView}, each showing an image + title for each page , by calling a serpated widget defined below 
    ✅ Keeping Drawer, EndDrawer, and FloatingActionButton for full lesson context.
 */

/*
  Lesson 26 - [TabBar] - Part 2 [current lesson  ]  
  ----------------------------------------
  Concepts:
    ✅ Using a custom TabController with SingleTickerProviderStateMixin
    ✅ Managing TabBar and TabBarView manually
    ✅ Adding navigation buttons using tabController.animateTo()
    ✅ Adding an image for each tab page
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

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  // Scaffold key to control Drawer
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  // Custom TabController
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text("TabBar Widget - Part 2"),
          backgroundColor: Colors.lightBlue,
          bottom: TabBar(
            controller: tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.white,
            labelStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(icon: Icon(Icons.computer), text: "PC"),
              Tab(icon: Icon(Icons.laptop), text: "Laptop"),
              Tab(icon: Icon(Icons.smartphone), text: "Mobile"),
            ],
          ),
        ),

        // Left Drawer
        drawer: Drawer(
          width: 280,
          backgroundColor: Colors.white,
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
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
                      title: Text("Shadi"),
                      subtitle: Text("shadidev@gmail.com"),
                    ),
                  ),
                ],
              ),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.home),
                title: Text('Home Page'),
              ),
              const ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Account'),
              ),
              const ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text('Orders'),
              ),
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('About Us'),
              ),
              const ListTile(
                leading: Icon(Icons.contact_phone),
                title: Text('Contact'),
              ),
            ],
          ),
        ),

        // Floating Action Button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            debugPrint('FAB pressed');
          },
          child: const Icon(Icons.add),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        // Main Content
        body: TabBarView(
          controller: tabController,
          children: [
            // --- Page 1: PC ---
            _buildTabContent(
              title: "PC Page",
              image: "assets/images/pc.jpg",
              buttons: [
                _navButton("Go to Laptop Page", 1),
                _navButton("Go to Mobile Page", 2),
              ],
            ),

            // --- Page 2: Laptop ---
            _buildTabContent(
              title: "Laptop Page",
              image: "assets/images/laptop.jpg",
              buttons: [
                _navButton("Go to PC Page", 0),
                _navButton("Go to Mobile Page", 2),
              ],
            ),

            // --- Page 3: Mobile ---
            _buildTabContent(
              title: "Mobile Page",
              image: "assets/images/mobile.jpg",
              buttons: [
                _navButton("Go to PC Page", 0),
                _navButton("Go to Laptop Page", 1),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper Widget: Builds each tab content with image & navigation buttons
  Widget _buildTabContent({
    required String title,
    required String image,
    required List<Widget> buttons,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(image, height: 220, fit: BoxFit.cover),
          ),
          const SizedBox(height: 25),
          ...buttons,
        ],
      ),
    );
  }

  /// Helper Widget: Navigation button
  Widget _navButton(String label, int index) {
    return ElevatedButton(
      onPressed: () => tabController.animateTo(index),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
