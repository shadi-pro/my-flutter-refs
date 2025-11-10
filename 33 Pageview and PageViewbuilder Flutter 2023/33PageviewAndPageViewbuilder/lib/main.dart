/*
   // --------------------------
  
  27- [ Pageview] & [PageViewbuilder] -  [current lesson]    : 
     - [Pageview]  ->  creating fixed  horizontal slider using fixed  children  of widgets     
     - [Pageview.builder()]   ->  creating dynamic horizontal slider using  item of defined list variable of widgets or values    


      *] App Overview
        This Flutter app demonstrates PageView and PageView.builder — two widgets used to swipe between multiple pages horizontally, like slides.
        It also includes:
          1- AppBar with a TabBar
          2- Drawer (side menu)
          3- BottomNavigationBar
          4- FloatingActionButton
         // ---------------------------------------
      
      🧩 Main Components Explained  
          🧱 1. AppBar + TabBar :
            - The AppBar displays the main title and three tabs (“PC”, “Laptop”, “Mobile”).
            - The TabController keeps track of which tab is active.
            - The indicatorColor and label styles highlight the selected tab.


          📚 2. Drawer (Left Menu) :
            - Contains user info (photo, name, email) + navigation links.
            - Opens from the left side; you can also open it using the FloatingActionButton.


          🖼️ 3. PageView :
            - Displays multiple pages that you can swipe through horizontally.
            - Each page shows an image and a title in a styled card.
            - The onPageChanged callback prints the current index in the console.

          ⚙️ 4. PageView.builder :
            - A dynamic version of PageView that generates items from a list (in this case, image paths).
            - More efficient when you have many pages because it builds them on demand.

          📱 5. BottomNavigationBar :
            - Lets you switch between sections like “User”, “Home”, “Settings”, and “Contact”.
            - Updates the active index and changes color on selection.

          ➕ 6. FloatingActionButton
            - Used to trigger an action — here, it opens the Drawer.
          // ------------------------------


      🎯  main benefits and feautures of  This Lesson :
          1- Difference between PageView and PageView.builder.
          2- How to combine multiple navigation tools (Tabs, Drawer, BottomNav)
          3- Handling missing assets safely with errorBuilder.
          4- Building clean, reusable Flutter UIs.
  // --------------------------

 */

// import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// A - Main class
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// B - State class
class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  // --- Variables ---
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  TabController? tabController;
  int selectedIndex = 0;

  final List<String> imageNames = [
    'assets/images/img1.jpg',
    'assets/images/img2.jpg',
    'assets/images/img3.jpg',
  ];

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.grey[200],

        // ---------------- App Bar ----------------
        appBar: AppBar(
          title: const Text(
            "PageView & PageView.builder Lesson",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          bottom: TabBar(
            controller: tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            labelColor: Colors.greenAccent,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(text: "PC", icon: Icon(Icons.computer)),
              Tab(text: "Laptop", icon: Icon(Icons.laptop)),
              Tab(text: "Mobile", icon: Icon(Icons.phone_android)),
            ],
          ),
        ),

        // ---------------- Drawer ----------------
        drawer: Drawer(
          width: 280,
          backgroundColor: Colors.white,
          child: ListView(
            padding: const EdgeInsets.all(15),
            children: [
              UserAccountsDrawerHeader(
                accountName: const Text("Shadi"),
                accountEmail: const Text("shadidev@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: const AssetImage("assets/images/shadi.jpg"),
                  onBackgroundImageError: (_, __) {
                    debugPrint("⚠️ Image not found: assets/images/shadi.jpg");
                  },
                ),
                decoration: const BoxDecoration(color: Colors.lightBlue),
              ),
              _drawerItem(Icons.home, "Home Page", () {}),
              _drawerItem(Icons.account_circle, "Account Page", () {}),
              _drawerItem(Icons.check_box, "Order Page", () {}),
              _drawerItem(Icons.info, "About Us", () {}),
              _drawerItem(Icons.phone, "Contact", () {}),
              _drawerItem(Icons.exit_to_app, "Sign Out", () {}),
            ],
          ),
        ),

        // ---------------- Body ----------------
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),

              // --- PageView Example ---
              _sectionTitle("A. PageView Example"),
              SizedBox(
                height: 250,
                child: PageView(
                  onPageChanged: (val) => debugPrint("PageView index: $val"),
                  children: [
                    _pageCard(
                      "PageView Page 1",
                      Colors.blue,
                      "assets/images/img1.jpg",
                    ),
                    _pageCard(
                      "PageView Page 2",
                      Colors.green,
                      "assets/images/img2.jpg",
                    ),
                    _pageCard(
                      "PageView Page 3",
                      Colors.orange,
                      "assets/images/img3.jpg",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- PageView.builder Example ---
              _sectionTitle("B. PageView.builder Example"),
              SizedBox(
                height: 250,
                child: PageView.builder(
                  itemCount: imageNames.length,
                  onPageChanged: (val) => debugPrint("Builder index: $val"),
                  itemBuilder: (context, i) {
                    return _pageCard(
                      "Builder Page ${i + 1}",
                      Colors.purple,
                      imageNames[i],
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // ---------------- Floating Action Button ----------------
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlue,
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
          child: const Icon(Icons.menu),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        // ---------------- Bottom Navigation ----------------
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
      ),
    );
  }

  // Helper widget for drawer items
  ListTile _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.lightBlue),
      title: Text(title),
      onTap: onTap,
    );
  }

  // Helper for section titles
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  // Helper for creating visual pages
  Widget _pageCard(String title, Color color, String imagePath) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withOpacity(0.3),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_not_supported,
                  size: 60,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(10),
              color: Colors.black54,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
