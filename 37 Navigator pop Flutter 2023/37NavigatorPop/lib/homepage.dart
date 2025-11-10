// [homepage] =>
//  a custom widget as a page  to be imported from antother files
// provided with 2 buttons of navigator to:
//  1- [About page widget] =>  (using the {.pushReplacement} type)]
//  2- [Contact page widget] =>  (using the {.push} type)]
import 'package:flutter/material.dart';
import 'package:first_app/customcard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),

      // 🧭 Drawer with profile image
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // 🔹 Profile header with your image
            UserAccountsDrawerHeader(
              accountName: const Text(
                'Shadi Ahmed',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text(
                'shadidev@gmail.com',
                style: TextStyle(fontSize: 14),
              ),
              currentAccountPicture: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset(
                  'assets/images/shadi.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              decoration: const BoxDecoration(color: Colors.blueAccent),
            ),

            // 🔹 Navigation list
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Navigated to About using Navigator.pushNamed()',
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/contact');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Navigated to Contact using Navigator.pushNamed()',
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You have logged out.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // 🧱 Main body
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: const [
            CustomListtile(
              name: "Sayed",
              email: "sayed@gmail.com",
              date: "25-6-2025",
              imagename: "assets/images/img1.jpg",
            ),
            CustomListtile(
              name: "Ali",
              email: "ali@gmail.com",
              date: "25-2-2025",
              imagename: "assets/images/img2.jpg",
            ),
            CustomListtile(
              name: "Mohamed",
              email: "mohamed@gmail.com",
              date: "25-8-2025",
              imagename: "assets/images/img3.jpg",
            ),
          ],
        ),
      ),

      // 🧭 Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page),
            label: 'Contact',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/about');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Navigated to About using BottomNav + pushNamed()',
                ),
                duration: Duration(seconds: 2),
              ),
            );
          }
          if (index == 2) {
            Navigator.pushNamed(context, '/contact');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Navigated to Contact using BottomNav + pushNamed()',
                ),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }
}
