// [homepage] =>
//  a  Home page  inlcuding several buttons to be used in routing to inner pages of app
// provided with 2 buttons of navigator to:
//  0- [ {homepage.dart} ] =>  (using the {.pushReplacement} type)]
//  1- [ {initstatedispose.dart} ] =>  (using the {.pushReplacement} type)]
//  2- [ {contact.dart} ] =>  (using the {.pushReplacement} type)]

import 'package:flutter/material.dart';
// import 'package:first_app/customcard.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Home page', style: TextStyle(color: Colors.black)),

        iconTheme: IconThemeData(color: Colors.grey[800]),
        backgroundColor: Colors.grey[200],
        elevation: 0.0,

        actions: [
          PopupMenuButton(
            // icon property [type + color]  :
            icon: Icon(Icons.menu, color: Colors.black),

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

      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              textAlign: TextAlign.center,
              "This lesson is about the both of initState and dipose function in navigation as practical exmaple \n The main concept of {initState()} and {dipose()} methods as following :   ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),

          SizedBox(height: 50),

          MaterialButton(
            onPressed: () => Navigator.of(context).pushNamed('popupmenubutton'),
            child: Text(
              "Go to Lesson page of [Popup Menu button ]",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // MaterialButton(
          //   onPressed: () => Navigator.of(context).pushNamed('listgenerate'),
          //   child: Text(
          //     "Go to Lesson page [Initial State and Dispose]",
          //     style: TextStyle(fontWeight: FontWeight.bold),
          //   ),
          // ),
        ],
      ),
    );
  }
}
