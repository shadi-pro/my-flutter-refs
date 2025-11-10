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

  7- [GridView]  => this lesson      [# 8:03 ]
    a-   [GridView]           => main widget [default children]   
    b-   [GridView.builder()] => extracted merthod of the main GridView  [ dynamic listing  item  ]
    c-   [GridView.count()]   => extracted merthod of the main GridView [default children]



   // This app descrption   :
      -- design a main a scroling vetically container with (2) Horizontal [listView] that including several children   , as the next structure   

      - Main Parent container  [SingleChildScrollView] [vertical axis]  => to activate vertical scroling  :
        -- Main Child container [Column] : include  (2)  children [continers] ) => 
          --- [title text] : lesson title          
          
          --- [first container] : include     
              1- [Gridview] with using  {builder} method  , including  the :
                a-  vertical axis     
                b-  item count of defined [list]    
                c-   return :
                  - 1 [Row]  , include  : 
                    --    (3) [Container]  , each one include   : 
                        -- [Text]  ,  include  :
                          child of :  dynamic  value of the innier object of the  defined [list] with                    
            
           
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

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('[GridView]  widget  ')),

        //  Main Parent Container  :
        body: Container(
          child:
          // A Extracted  [ GridView.builder() ]  ->   extracted method from  [GridView]  widget :
          GridView.builder(
            // 1-  [gridDelegate]  =>  control properoies of the Grid children  [ for each of the {GridView.builder()} & {GridView}  ]   :
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  2, // [ count of the  children in a row in the Grid  ]
              mainAxisSpacing:
                  10, //  [ Vertical space between children in the grid   {the main axis of the [GridView] is vertical }   ]
              crossAxisSpacing:
                  10, // [ Horizontal  space between children in the grid]
              childAspectRatio:
                  1, // [ {vertical percentage} to the {horizontal space} of each child  in the grid - default value = [0]  -     ]
              mainAxisExtent:
                  100, // [ {fixed vertical child height } -  regardliess to previous assinged value of the  {childAspectRatio}   -   ]
            ),

            //  2- [itemCount] => this property is items of looped defined list count [basic property of GridView.builder()  ]  :
            itemCount: employee.length,

            //  3- [itemBuilder] => the item to be built for each item  of looped inside the defined list  [basic property of  GridView.builder() ]  :
            itemBuilder: (context, index) {
              return Container(
                color: Colors.blue, // make the item visible
                alignment: Alignment.center,
                child: Text(
                  employee[index]['name'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              );
            },
          ),

          // B] Main [GridView] widget  :
          //  GridView (
          //  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          //   crossAxisCount: 2  ,   // [ count of the  children in a row in the Grid  ]
          //   mainAxisSpacing: 10 , //  [ Vertical space between children in the grid   {the main axis of the [GridView] is vertical }   ]
          //   crossAxisSpacing: 10 , // [ Horizontal  space between children in the grid]
          //   childAspectRatio: 1 ,    // [ {vertical percentage} to the {horizontal space} of each child  in the grid - default value = [0]  -     ]
          //   mainAxisExtent : 1    // [ {fixed vertical child height } -  regardliess to previous assinged value of the  {childAspectRatio}   -   ]
          // ) ,

          //  children [
          //  Container ( child : Text () , color: Colors.red  )  ,
          //  Container ( child : Text () , color: Colors.red  )  ,
          //  Container ( child : Text () , color: Colors.red  )  ,
          //  Container ( child : Text () , color: Colors.red  )  ,
          // ]
          // ) ;

          // C]   Exracted [GridView.count() ]   widget  :
          //   GridView (
          //   scrollDirection: Axis.horizontal ,   // [ contoring the deirection of grid extended flow (default value is vertical )   ]
          //   crossAxisCount: 2  ,   // [ count of the  children in a row in the Grid  ]
          //   mainAxisSpacing: 10 , //  [ Vertical space between children in the grid   {the main axis of the [GridView] is vertical }   ]
          //   crossAxisSpacing: 10 , // [ Horizontal  space between children in the grid]
          //   childAspectRatio: 1 ,    // [ {vertical percentage} to the {horizontal space} of each child  in the grid - default value = [0]  -     ]
          //   mainAxisExtent : 1    // [ {fixed vertical child height } -  regardliess to previous assinged value of the  {childAspectRatio}   -   ]
          //   reverse : true ;     //  [ reverased viewing of inner children ]
          // ) ,

          //  children [
          //  Container ( child : Text () , color: Colors.red  )  ,
          //  Container ( child : Text () , color: Colors.red  )  ,
          //  Container ( child : Text () , color: Colors.red  )  ,
          //  Container ( child : Text () , color: Colors.red  )  ,
          // ]

          // ) ;
        ),
      ),
    );
  }
}
//  --------------
  