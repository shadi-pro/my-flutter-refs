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
   
  9- [ Icon ]  &  [IconButton]  : 
   -- [Icon]       >  
   -- [IconButton] >   
   
  10- [ Expanded  ]   Widget  
  // ----------------------

    * [ Example part 1  ] =>  about all previous lessons to implement a UI flutter design using all studied widgets  :
    - This application will include some new properties of widgets      
      
   // This app descrption   :
      - design a main container [Container] , that include one [Column] that contains => children [3 Containers ] as following   : 
        -- [First Container] =>    
           has special  properites  + include [Text]   

        -- [Second Container] =>    
            has special  properites  + include [Text]   

        -- [Third Container] =>    
          has special  properites  + include: 
            --- [ Row ] =>  include  (2) children  : 
              -----  [Row] -> contains (5) icons of stars 
              -----  [Text] -> contains text of reviewer count   
  ----------------------- 

  * [ Example part 2] =>
    - complete  designing the  previous application , as following: 
      --  adding new container child [Container ]  wihtin the direct parent container  [column]  -> that will include one container {Row} , which will : 
        --- (3)  [children]  {Column}
        ---  alinging hte inner childner using one olny  of  the  next  methods : 
            a-  [ MainAxisAligment  ] property  of parent  contern   [Row] 
            b-  [ Spacer()] child  widget in-between the inner  children of main  Container  [Row]        
  -----------------------------

  11-  [ Button]  widgets  => 
    a-    { MaterialButton(  ) } widget type   
    b-    { IconButton(  ) } widget type   
    c-    { floatinhgActionButton(  ) } widget type   
  -----------------------------
 


*/
// --------------------------

// import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // app bar of the main screen :
        appBar: AppBar(title: const Text(' Button widgets types  ')),

        // add  third type  of button  floating action button of the main screen  :
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('Hello from the main float action button ');
          },
          child: Icon(Icons.add),
        ),

        // controling Loction of [floatingActionButton] using the [floatingActionButtonLocation] property  :
        floatingActionButtonLocation:
            FloatingActionButtonLocation
                .endFloat, // [ centerTop , centerFloat ,  endFloat, startFloat , ......    ]

        body:
        // [the main container of the  all  page ]
        Container(
          padding: EdgeInsets.all(
            10,
          ), // [this will set main container with inner padding  to set all its children in full width - instead of setting each widget ]

          child: Column(
            children: [
              // First type of the button in the flutter   [MaterialButton]   :
              MaterialButton(
                // value of this button   :
                onPressed: () {
                  // function of the simple click on this  button :
                  print("hello world ,  simple click   ");
                },

                // function of the long click on this  button :
                onLongPress: () {
                  print("hello world ,  long click   ");
                },

                // button  Background color       :
                color: Colors.blue,

                // button value  color       :
                textColor: Colors.white,

                // button  min width to allow auto fit  :
                minWidth: 200,

                // button fixed Height    :
                height: 100,

                //  button padding p[using the symtric  ]   :
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),

                // value of this button   :
                child: Text("Click "),
              ),

              // Second type of the button in the flutter  [IconButton] :
              IconButton(
                onPressed: () {
                  print("you single clicked on the  IconButton type   ");
                },

                onLongPress: () {
                  print("you long  clicked on the  IconButton type   ");
                },

                icon: Icon(Icons.person),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//  --------------
  