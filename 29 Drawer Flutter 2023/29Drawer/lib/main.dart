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
  // 🔹 Key to control Drawer and EndDrawer without needing AppBar buttons
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldkey,

        // ✅ AppBar
        appBar: AppBar(
          title: const Text("Drawer Widget"),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          elevation: 4,
        ),

        // ✅ Left Drawer
        drawer: Drawer(
          elevation: 5,
          backgroundColor: Colors.green[100],
          width: 300,
          child: ListView(
            padding: const EdgeInsets.all(15),
            children: [
              // 🔹 Drawer Header (Profile Section)
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
                      title: Text('Shadi', overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                        'shadidev@gmail.com',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1),

              // 🔹 Drawer Menu Items
              _buildDrawerItem(Icons.home, 'Home Page', 'Opening Home Page...'),
              _buildDrawerItem(
                Icons.account_circle,
                'Account Page',
                'Opening Account Page...',
              ),
              _buildDrawerItem(
                Icons.shopping_cart,
                'Order Page',
                'Opening Orders Page...',
              ),
              _buildDrawerItem(
                Icons.help,
                'About Us Page',
                'Opening About Us Page...',
              ),
              _buildDrawerItem(
                Icons.phone_android,
                'Contact Page',
                'Opening Contact Page...',
              ),
              _buildDrawerItem(
                Icons.exit_to_app,
                'Signout',
                'Signing out... Goodbye!',
              ),
            ],
          ),
        ),

        // ✅ Right Drawer (End Drawer)
        endDrawer: Drawer(
          backgroundColor: Colors.blue[50],
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: const [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blueAccent),
                child: Center(
                  child: Text(
                    'Right Drawer Header',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
              ListTile(leading: Icon(Icons.info_outline), title: Text('Info')),
              ListTile(leading: Icon(Icons.logout), title: Text('Logout')),
            ],
          ),
        ),

        // ✅ Floating Action Button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(scaffoldkey.currentContext!).showSnackBar(
              const SnackBar(content: Text('Hello from the Drawer Example!')),
            );
          },
          backgroundColor: Colors.redAccent,
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        // ✅ Main Body
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                color: Colors.redAccent,
                textColor: Colors.white,
                onPressed: () {
                  scaffoldkey.currentState!.openDrawer();
                },
                child: const Text('Open Drawer'),
              ),
              const SizedBox(height: 10),
              MaterialButton(
                color: Colors.blueAccent,
                textColor: Colors.white,
                onPressed: () {
                  scaffoldkey.currentState!.openEndDrawer();
                },
                child: const Text('Open EndDrawer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Drawer item builder with SnackBar support
  Widget _buildDrawerItem(IconData icon, String title, String message) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title),
      onTap: () {
        // Close the drawer before showing SnackBar
        Navigator.of(context).pop();
        // Show SnackBar
        ScaffoldMessenger.of(scaffoldkey.currentContext!).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }
}
