/*
Lesson #40: showBottomSheet() & SnackBar()

🧠 Concepts Covered BRIEFLY :
  - How to display a persistent Bottom Sheet using showBottomSheet()
  - How to close it and trigger a SnackBar
  - Integration with Drawer, FAB, and BottomNavigationBar
  - Reusable Custom Widget (CustomCard)

🎯 Lesson Objective :
  - To understand how to:
    1- Display a Bottom Sheet dynamically using showBottomSheet().
    2- Close it programmatically using Navigator.pop().
    3- Use a SnackBar to show quick user feedback when an action happens (like opening or closing the sheet).
    4- Integrate both with existing app elements such as Drawer, BottomNavigationBar, and FAB.


🧩 Main Concepts Covered
  1️⃣ showBottomSheet() :
    - This method opens a persistent bottom sheet at the bottom of the screen.
    - It remains visible while the user interacts with other parts of the screen.
    - It can be customized with any widget structure (text, buttons, images, etc.).
    - It returns a PersistentBottomSheetController, which we can use to control or close the sheet later.

    _bottomSheetController = _scaffoldKey.currentState!.showBottomSheet(
      (context) => Container(
        height: 200,
        color: Colors.white,
        child: Center(child: Text("Hello from Bottom Sheet")),
      ),
    );


  2️⃣ Navigator.pop(context) :
    - Used here to close the bottom sheet.
    - In general, Navigator.pop() removes the current screen or modal from the navigation stack.
 

  3️⃣ SnackBar :
      - Displays short, lightweight messages at the bottom of the screen.
      - Often used for feedback, like confirming an action or showing a warning.

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Bottom Sheet Closed!"),
          duration: Duration(seconds: 2),
        ),
      );

 
  4️⃣ ScaffoldMessenger :
    - This is the new (and recommended) way to show SnackBars.
    - Unlike the old Scaffold.of(context), it works even if your Scaffold isn’t the nearest ancestor.



  ⚙️ How the Flow Works  :
    1️⃣ The app starts on the HomePage, which contains multiple user cards (from CustomCard widget).
    2️⃣ When you tap the Floating Action Button (FAB), it calls _showCustomBottomSheet().
    3️⃣ This function opens a Bottom Sheet and displays a SnackBar saying “Bottom Sheet Opened!”
    4️⃣ Inside the Bottom Sheet, there’s a button labeled Close Sheet.
    5️⃣ When pressed, it uses Navigator.pop(context) to close the sheet, and then displays another SnackBar saying “Bottom Sheet Closed!”.
    6️⃣ The Drawer still contains your personal info with your image (shadi.jpg) and navigation links to switch between “Home” and “About” pages.

  🧭 App Components in Action :
    Component Description Drawer Contains your profile and navigation links (Home / About).
    BottomNavigationBar Switches between two main pages.
    FAB (Floating Action Button)Opens the Bottom Sheet on click.Bottom SheetA temporary sliding panel from the bottom with custom content.
    SnackBar Displays messages when Bottom Sheet is opened or closed.
    CustomCard Widget Reusable widget for displaying user info cards.

  💡 Key Notes :
    ✅ showBottomSheet() → Creates a persistent bottom sheet that stays attached to the Scaffold.
    ✅ showModalBottomSheet() → Creates a modal sheet (blocks the background).
    ✅ Always manage only one open sheet at a time by storing the controller.
    ✅ SnackBar is ideal for short-lived status messages.
    ✅ Use ScaffoldMessenger.of(context) to safely show SnackBars across routes.


  🧩 Summary
    - ActionMethod UsedResultOpen Bottom SheetshowBottomSheet()Bottom panel slides upClose Bottom SheetNavigator.pop(context)Sheet disappearsShow FeedbackSnackBarUser sees confirmation message
 
*/

import 'package:flutter/material.dart';
import 'package:first_app/homepage.dart';
import 'package:first_app/about.dart';
import 'package:first_app/customcard.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? _bottomSheetController;

  final List<Widget> _pages = [const Homepage(), const AboutPage()];

  void _showCustomBottomSheet(BuildContext context) {
    if (_bottomSheetController != null) return; // Prevent multiple sheets

    _bottomSheetController = _scaffoldKey.currentState!.showBottomSheet(
      (context) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        height: 200,
        child: Column(
          children: [
            const Text(
              "🎯 This is a Bottom Sheet",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ Bottom Sheet Closed!"),
                    duration: Duration(seconds: 2),
                  ),
                );
                _bottomSheetController = null;
              },
              icon: const Icon(Icons.close),
              label: const Text("Close Sheet"),
            ),
          ],
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("📥 Bottom Sheet Opened!"),
        duration: Duration(seconds: 2),
      ),
    );

    _bottomSheetController!.closed.then((_) {
      _bottomSheetController = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: " showBottomSheet & SnackBar",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text("BottomSheet & SnackBar"),
          backgroundColor: Colors.lightBlue,
        ),

        // 🧭 Drawer
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              // Profile section
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      "assets/images/shadi.jpg",
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: ListTile(
                      title: Text("Shadi Ahmed"),
                      subtitle: Text("shadidev@gmail.com"),
                    ),
                  ),
                ],
              ),
              const Divider(),

              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home"),
                onTap: () {
                  setState(() => selectedIndex = 0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text("About"),
                onTap: () {
                  setState(() => selectedIndex = 1);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),

        // 🧭 Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          onTap: (index) => setState(() => selectedIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
          ],
        ),

        // 🧱 Floating Action Button to show bottom sheet
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showCustomBottomSheet(context),
          icon: const Icon(Icons.arrow_upward),
          label: const Text("Show Sheet"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        // 🧩 Main Body (switch between pages)  according to assigned selected index
        body: _pages[selectedIndex],
      ),
    );
  }
}
