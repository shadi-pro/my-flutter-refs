/*
 Lessons applied in this application :  
   1- [Text] widget 
   2- [Container] s widget 
   3- [Image] widget
   4- [Column] & [Row] widget
   5- [Wrap] widget & [SingleChildScrollView] Widget 
   6- [ListView] Widget ->   the main widget  , and include the next extracted methdos of inner  types  :           
      a- {ListView.builder()}  =>  
      b- {ListView.seperasted()}  => 

  7- [GridView]  => 
    a-   [GridView]           => main widget [default children]   
    b-   [GridView.builder()] => extracted merthod of the main GridView  [ dynamic listing  item  ]
    c-   [GridView.count()]   => extracted merthod of the main GridView [default children]

  8- [Card]  &  [TitleView] => this lesson  :
   -- [Card] > the main container of ceratin properties  
   -- [ListTile] >   the main child of  the Card   
  // ----------------------

  9- [ Icon ]  &  [IconButton] => this lesson  :
   -- [Icon]       >  
   -- [IconButton] >   
  // ----------------------
  
   // This app descrption   :
      - design a main continer of [Listview]  that include (2)  of [Cards] widgets   with its own chldren , as the next structure : 

      - Main Parent container  [Container]    => to inclde main (1) [listView]  child container , of (2) [Icon] & [IconButton] ,   as following  :
        --  [Icon] ->  
      
        --  [IconButton]  ->  
          
           
*/
// --------------------------

// import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('[ Icon ]  & [ IconButton ] widget  '),
        ),

        //  Main Parent Container  :
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const Center(
                child: Icon(Icons.person, color: Colors.red, size: 100),
              ),
              const SizedBox(height: 20),
              Center(
                child: IconButton(
                  onPressed: () {
                    print('You clicked on the icon button!');
                  },
                  icon: const Icon(Icons.person),
                  color: Colors.blue,
                  iconSize: 100,
                  splashRadius: 60, // nice ripple radius
                  tooltip: 'Click me!', // shows hint when long-pressed
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//  --------------
  