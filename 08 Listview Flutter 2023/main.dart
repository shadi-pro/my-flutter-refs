/*
 Lessons applied in this application :  
   1- [Text] widget 
   2- [Container] s widget 
   3- [Image] widget
   4- [Column] & [Row] widget
   5- [Wrap] widget & [SingleChildScrollView] Widget 
   5- [ListView] Widget with  {builder()}  => this lesson    

   // This app descrption   :
      -- design a main a scroling vetically container with (2) Horizontal [listView] that including several children   , as the next structure   

      - Main Parent container  [SingleChildScrollView] [vertical axis]  => to activate vertical scroling  :
        -- Main Child container [Column] : include  (2)  children [continers] ) => 
          --- [title text] : lesson title          
          
          --- [first container] : include     
              1-  [listview] with using  {builder} method  , inclding  the :
                a-  vertical axis     
                b-  item count of  deifnd [list]    
                c-   return :
                  - 1 [Row]   , include  : 
                    --    (3)  [Container]  , each one include   : 
                        -- [Text]  ,  include  :
                          child of :  dynamic  value of the innier object of the  defined [list] with                    
            
          ---  second [container] ,  include :   
              1- default [listview] :   include several children  :     
            ----  4 free [containers]               
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
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('[ListView]  widget (default and custom )'),
        ),

        //  Main Parent Container  :
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          
          //  Main Child Container  :
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Application title :
              Text(
                'The  employee list  ',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              //  [First Container] -> looping in defined list {employee} using  [listview] and {builder()} inner method   :
              Container(
                height: 300,
                color: Colors.red   ,  
                
                child: ListView.builder(
                  scrollDirection:   Axis.vertical  ,
                  
                  itemCount: employee.length, // [set the  looping count as the defined  List length ]
                  
                  itemBuilder: (context, i) {   // [ this method will access the defined variables in this file inside the return  , by using (contex , index)  ] 
                    
                    // [ looping method according  to the (2) parameters (context : value, index  )  ]
                    return Row(
                      children: [
                        Container(
                          
                          margin: EdgeInsets.all(5),
                          // decoration: BoxDecoration(
                          //   border: Border.all(width: 3),
                          //   ),

                          child: Text(
                            employee[i]['name'],
                            style: TextStyle(fontSize: 25 , color: Colors.white ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.all(5),
                          // color: Colors.red   ,                            
                          // decoration: BoxDecoration(
                          //   border: Border.all(color: Colors.red, width: 3),
                          // ),

                          child: Text(
                            employee[i]['age'],
                            style: TextStyle(fontSize: 25 , color: Colors.white  ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.all(5),
                          // color: Colors.red   ,  
                          // decoration: BoxDecoration(
                          //   border: Border.all(color: Colors.red, width: 3),
                          // ),

                          child: Text(
                            employee[i]['city'],
                            style: TextStyle(fontSize: 25 , color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              Container (
                height: 1000,                
                child: ListView(
                  scrollDirection: Axis.vertical,
                  
                  children: [
                    Container(width: 200, height: 100, color: Colors.blue),
                    Container(width: 200, height: 100, color: Colors.yellow),
                    Container(width: 200, height: 100, color: Colors.red),
                    Container(width: 200, height: 100, color: Colors.green),
                    Container(width: 200, height: 100, color: Colors.brown),
                  ],
                )
              ) 

            ],
          ),
        ),
      ),
    );
  }
}
//  --------------
  