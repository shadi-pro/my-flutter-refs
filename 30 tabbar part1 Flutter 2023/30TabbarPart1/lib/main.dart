/*
 Lessons applied in this application :   
  
  30- [Tabbar]  - part 1 
    ✅ Creating (3) {Tab()} inside the [TabBar] within {AppBar}.
    ✅ Adding (3) children inside {TabBarView}, each showing an image + title for each page , by calling a serpated widget defined below 
    ✅ Keeping Drawer, EndDrawer, and FloatingActionButton for full lesson context.
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
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          key: scaffoldkey,
          appBar: AppBar(
            title: const Text("TabBar Widget - Part 1"),
            bottom: const TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(icon: Icon(Icons.laptop), text: "Laptop"),
                Tab(icon: Icon(Icons.smartphone), text: "Mobile"),
                Tab(icon: Icon(Icons.computer), text: "PC"),
              ],
            ),
          ),

          // Drawer on left
          drawer: Drawer(
            backgroundColor: Colors.green[100],
            width: 280,
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                const SizedBox(height: 20),
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
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home Page'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Account Page'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          endDrawer: const Drawer(),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ScaffoldMessenger.of(scaffoldkey.currentContext!).showSnackBar(
                const SnackBar(content: Text('Hello from TabBar example!')),
              );
            },
            child: const Icon(Icons.add),
          ),

          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

          body: TabBarView(
            children: [
              _buildTabPage("Laptop Page", "assets/images/laptop.jpg"),
              _buildTabPage("Mobile Page", "assets/images/mobile.jpg"),
              _buildTabPage("PC Page", "assets/images/pc.jpg"),
            ],
          ),
        ),
      ),
    );
  }

  // seperated Helper widget with properrties  for each tab page go be caleed inside [TabBarView] children:
  Widget _buildTabPage(String title, String imagePath) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 250, height: 180, fit: BoxFit.cover),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
