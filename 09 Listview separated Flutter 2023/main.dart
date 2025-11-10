/*
 Lessons applied in this application :  
   1- [Text] widget 
   2- [Container] s widget 
   3- [Image] widget
   4- [Column] & [Row] widget
   5- [Wrap] widget & [SingleChildScrollView] Widget 
   6- [ListView] Widget ->   the main widget  , and include the next extracted methdos of inner  types  :           
      a- {ListView.builder()}  =>  
      b- {ListView.seperasted()}  => this lesson    

   // This app descrption   :
      -- design a main a scroling vetically container with (2) Horizontal [listView] that including several children   , as the next structure   

      - Main Parent container  [SingleChildScrollView] [vertical axis]  => to activate vertical scroling  :
        -- Main Child container [Column] : include  (2)  children [continers] ) => 
          --- [title text] : lesson title          
          

          ---  [container] ,  include :   
                (1) sepearated list view [ListView.separated] : looping inside  a  defined list + using separated / divider]   , with the next propertiers   :     
                  ----   1-  [separatorBuilder]  =>  this property of the [sepereator] of list , can be determined (2) method   =>    [divider "Divider : built-in widget" used in this file  ]   ||  ["Container: custom] :               
                  ----   2- [itemCount] => this property is items list count [basic property of ListView]  -> set by the defined list's length 
                  ----   3- [itemBuilder]   the item builder method to loop inside the  defined list  [basic property of ListView] 
                  ----   4- [ shrinkWrap]  :  this  property controling the [shrink] feauture  of [listView's  content] according to  contents size    [basic property of ListView]   : 
                  ----   5- [physics]  :  this  property controling the  [scollng] feature the listView   [basic property of ListView] -> [not  used in this applicatoin ] 
*/
// --------------------------

// import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  // Define a custom list of  data    :
  List employee = [
    {'name': 'Shadi', 'age': '31', 'city': 'Cairo'},
    {'name': 'Sayed', 'age': '35', 'city': 'Cairo'},
    {'name': 'Ramiz', 'age': '29', 'city': 'Cairo'},
    {'name': 'Ali', 'age': '43', 'city': 'Cairo'},
    {'name': 'Mohammed', 'age': '43', 'city': 'Cairo'},
    {'name': 'Ahmed', 'age': '43', 'city': 'Cairo'},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('[ListView]  widget ( custom and seperated  )'),
        ),

        //  Main Parent Container  :
        body: Container(
          child: ListView.separated(
            // 1-  [separatorBuilder]  =>  this property of the [sepereator] of list , can be determined (2) method   =>    [divider "Divider : built-in widget"]   ||  ["Container: custom] :
            separatorBuilder: (context, index) {
              // [advanded feature of the {listView.separated()} type  ]

              // a- [divider "Divider : built-in widget"]  :
              return Divider(color: Colors.black, thickness: 5);

              // b- ["Container: custom  widget ] :
              // return Container(  color : Colors.black  , height: 5  ) ;
            },

            //  2- [itemCount] => this property is items list count [basic property of ListView]  :
            itemCount: employee.length,

            //  3- [itemBuilder]   the item builder method to loop inside the  defined list  [basic property of ListView]   :
            itemBuilder: (context, index) {
              return Container(
                height: 100,
                color: index.isEven ? Colors.red : Colors.green,

                child: Text(
                  employee[index]['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              );
            },

            // 4-  [physics]  :  this  property controling the  [scollng] feature the listView   [basic property of ListView]   :
            // physics:   NeverScrollableScrollPhysics(), //  [this value will stop the scollng feature the listView ]

            // 5- [ shrinkWrap]  :  this  property controling the [shrink] feauture  of [listView's  content] according to  contents size    [basic property of ListView]   :
            shrinkWrap:
                true, //  [this property will make  list auto shrink or extend according to its  contents ]
          ),
        ),
        ),
    );
  }
}
//  --------------
  