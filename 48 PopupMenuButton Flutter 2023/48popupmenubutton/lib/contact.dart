// [contact] =>
//  an inner page to be used in routing  in the main page

import 'package:flutter/material.dart';
// import 'package:first_app/customcard.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  //  using the initial state to display a message before page  load being loaded ;
  @override
  void initState() {
    print('====================   welcome to Contact  page ');
    super.initState();
  }

  // using the [dispose]  to display a message after this page is  being removed from pages qeue [incase of using navigation to homepage (that used {pushNamedAndRemoveUntil} method ) ]  ;
  @override
  void dispose() {
    print(
      '====================  Good bye to Contact  page after being unloaded due to using [ pushNamedAndRemoveUntil ] navigation method   ',
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' Contact inner  page',
          style: TextStyle(color: Colors.black),
        ),

        iconTheme: IconThemeData(color: Colors.grey[800]),
        backgroundColor: Colors.grey[200],
        elevation: 0.0,
      ),

      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        selectedItemColor: Colors.orange,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: "Shopping",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "Setting",
          ),
        ],
      ),

      body: ListView(
        children: [
          //  navigator to [Home page] :
          MaterialButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil("homepage", (route) => false);
            },
            child: Text("Go to Home page "),
          ),

          //  navigator to [ lesson page {InitStateDispose} ] :
          MaterialButton(
            onPressed: () => Navigator.of(context).pushNamed('listgenerate'),
            child: Text("Go to Lesson page [Initial State and Dispose]"),
          ),
        ],
      ),
    );
  }
}
