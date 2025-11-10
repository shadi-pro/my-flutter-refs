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
  
   // This app descrption   :
      - design a main continer of [Listview]  that include (2)  of [Cards] widgets   with its own chldren , as the next structure : 

      - Main Parent container  [Container]    => to inclde main (1) [listView]  chld container , of (2) [Cards] , each card will be as following  :
        -- [ First card] ->  
         ---  Cards's  child  :   will inlcude the card's  built-in  {ListTile} , with certain next properties  : 
            -----  [enabled ] :  default value of  'true'    
            -----  [isThreeLine ] :    'false'    

         ---  Cards's public properties :   will inlcude the card certain properties , including all types of  titles 

        -- [ Second  card] ->  
         ---  Cards's  child  :   will inlcude the card's  built-in  {ListTile} , with certain next properties  : 
            -----  [enabled ] :     'false'    
            -----  [isThreeLine ] :   'true'    

         ---  Cards's public properties :   will inlcude the card certain properties , including all types of  titles 
        
           
*/
// --------------------------

// import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('[ Card]  & [ListTile ]  widget  ')),

        //  Main Parent Container  :
        body: Container(
          child: ListView(
            children: [  // [ this list conineer qiwll  include 2 cards    ]  
              // first card inside the [listView] :
              Card(

                // 1-  public properties of [Card] :
                color: Colors.red,
                elevation:  0.0, // [ break line between cards  ( 0 : this value will remove the break line )  ]
                
                margin: EdgeInsets.only(bottom: 20),

                //  [assign a certain shape of the card's border ]
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                // 2-  child of the [Card]   :
                child: ListTile(
                  enabled: false, // [ ths property will control the  display of card contents +  and also will deactivate any defind mehtod on this card  ]

                  leading: Text("Card  Leading "),   // [ the top of  the main title ]

                  // [assign  method of on  long press  event  ] :
                  onLongPress: () {
                    print(
                      " card1 has been long pressed :  this value will be printed in the console ",
                    );
                  },

                  // [assign  method of on single  click event  ] :
                  onTap: () {
                    print(
                      " card1 has been clicked :  this value will be printed in the console ",
                    );
                  },
                  title: Text("Card title "),
                  subtitle: Text("Card SubTitle "),
                  trailing: Text("Card Trailing "),
                ),
              ),

              // seocnd  card inside the [listView] :
              Card(
                // 1- main properties of [Card] :
                color: Colors.red,
                elevation:
                    1.0, // [ break line between cards  ( 0 : this value will remove the break line )  ]
                
                // 2-  child of the [Card]   :
                child: ListTile(
                  leading: Text("Card  Leading "),
                  // [assign  method of on  long press  event  ] :
                  onLongPress: () {
                    print(
                      " card2 has been long pressed :  this value will be printed in the console ",
                    );
                  },

                  // [assign  method of on single  click event  ] :
                  onTap: () {
                    print(
                      " card2 has been clikded :  this value will be printed in the console ",
                    );
                  },
                  
                  isThreeLine:   true, // [  to align all types of titles ]
                  
                  title: Text("Card title "),
                  subtitle: Text("Card SubTitle "),
                  trailing: Text("Card Trailing "),
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
  