/* {popupmenubutton.dart}  => inner page of  to be navigated through route button in {homepage}  :
  - some practical apps on usage of {PopupMenuButton} widget            
   


*/

import 'package:flutter/material.dart';

class Popupmunubutton extends StatefulWidget {
  const Popupmunubutton({super.key});

  @override
  State<Popupmunubutton> createState() => _PopupmunubuttonState();
}

class _PopupmunubuttonState extends State<Popupmunubutton> {
  //  using the initial state to display a message before page  load being loaded ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' [Popup Menu button ] Lesson page',
          style: TextStyle(color: Colors.black),
        ),

        iconTheme: IconThemeData(color: Colors.grey[800]),
        backgroundColor: Colors.grey[200],
        elevation: 0.0,

        actions: [
          PopupMenuButton(
            // icon property [type + color]  :
            // icon: Icon(color: Colors.black),

            // icon size  :
            iconSize: 30,

            // [this [method property will be executed by selecting an item from list , and will returin the programing value of the selected item ]
            // [this method property  can be used in advanced functions according to the selected item ]
            onSelected: (val) {
              print('the ${val} is selected ');
            },

            // this method property will be executed by once the selelct menu is being opened ]
            onOpened: () => print("the select menu is opened!"),

            // this method property will be executed by once the selelct menu is being canceled]
            onCanceled: () => print("the select menu is Canceled!"),

            // [the itembuilder is returning list of items] :
            itemBuilder: (context) => [
              // [  each  is  including 2 mainly required prameters main {child : the label value} and {value : the programing value }  ]
              PopupMenuItem(
                child: Text('one'),
                value: 'valOne',
                onTap: () {
                  print('First item is selected ');
                },
              ),
              PopupMenuItem(
                child: Text('two'),
                value: 'valTwo',
                onTap: () {
                  print('Second is selected ');
                },
              ),
            ],
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        selectedItemColor: Colors.orange,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: "Lesson",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "Setting",
          ),
        ],
      ),

      body: ListView(
        children: [
          // MaterialButton(
          //   onPressed: () => Navigator.of(context).pushNamed('contact'),
          //   child: Text("Go to Contact page "),
          // ),
          MaterialButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil("homepage", (route) => false);
            },
            child: Text("Go to Home page"),
          ),
        ],
      ),
    );
  }
}
