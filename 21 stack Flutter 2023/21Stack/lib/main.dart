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
 
  11-  [ Button]  widgets  => 
    a-    { MaterialButton(  ) } widget type   
    b-    { IconButton(  ) } widget type   
    c-    { floatinhgActionButton(  ) } widget type   
  -----------------------------
 
  12-  [  StatefulWidget ] &  [Statelesswidget ]   => 
    a-    { setState() {} } interactive method used inside [StatefulWidget] 
    b-    creating  counter app 
    c-    creating clickable favourate rating   star app [2 clicakble buttons ]
  -----------------------------
 
  13-  [  SwitchListTile ] &  [ Switch ]  => 
       { setState() {} }  interactive method used inside [StatefulWidget]  wiht the  both of Switch and [SwtichListTile] 
  -----------------------------
 
  14-  [ Radio ] &  [ RadioListTile ]  =>  
      [2]  examples =>   
        a- [widget description - choose your country ] => using  a string value for Radio value  + {setState} for live responding       
        b- [widget description - choose your age ]  => using  a intger value for Radio value  + {setState} for live responding               
  -----------------------------
 
  15-  [ Checkbox ] &  [ CheckboxListTile ]    =>  
      [2]  examples =>   
        a- First example [ {Checkbox} widget description ] =>  [using {checkbox}  + {Text} widget]  {hobby choosing} 
        b- Second example [ {CheckboxListTile} widget description ] =>  [using { CheckboxListTile}  widget]  { languages choosing} 
          
  -----------------------------
 
  16-  [ Stack ] & ( current )  =>  
      [ ]  examples =>   
        a- First example [ {Stack} widget description ] =>  [using  ]   
           
  -----------------------------
 

*/
// --------------------------

// import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// A- creating the main  [ MyApp ]  as inherited from  the  built-in class [StatelessWidget]  :
class MyApp extends StatefulWidget {
  // 1- define an object from this class wiht using the [key] parameter with using the super keyword   :
  const MyApp({super.key});

  // 2- define a private method of state type  :
  @override
  State<MyApp> createState() => _MyAppState();
}

// B- define a new class from  the defiend private metod [_MyAppState] :
class _MyAppState extends State<MyApp> {
  // a-  define  public variables  :
 
  //-------------------------------------

  // b- using widget building function   :
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // app bar of the main screen :
        appBar: AppBar(title: const Text(' [Stack] widget ')),

        // add  floating action button of the main screen :
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('Hello from the main float action button ');
          },
          child: Icon(Icons.add),
        ),

        // assign  Loction of [floatingActionButton] using the [floatingActionButtonLocation] property :
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        // [the main container of the  all  page ]
        body: Container(
          padding: EdgeInsets.all(
            10,
          ), // [this will set main container with inner padding  to set all its children in full width - instead of setting each widget ]

          child: Stack(
            alignment: Alignment.center, // [  the main alignment of the stack for all its children]
              
            clipBehavior: Clip.none,   // [this property should display  the negative children that may break the current parent width of stack    ]

            children: [
              
              // first lower layer container   :
              Container(
                width: 300,
                height: 300,
                color: Colors.red,
                child: Text('first lower layer container '),
              ),

              // second lower layer container   :
              Container(
                width: 200,
                height: 200,
                color: Colors.blue,
                child: Text('Second higher  layer container   : '),
              ),


              // third  higher layer container   :
              Container(
                width: 100,
                height: 100,
                color: Colors.green,
                child: Text('third  higher layer container '),
              ),
    
              // horizontal stretched left - right container :
              Positioned(
                right: 0 ,
                left: 0 , 
                child:Container(
                  width: 100,
                  height: 100,
                  color: Colors.green,
                  child: Text('horizontal stretched left - right container '),
                ),
              ) , 

              // vertical stretched top - bottom  container :            
              Positioned( 
                top : 0 ,
                bottom: 0  ,
                child:Container(
                  width: 100,
                  height: 100,
                  color: Colors.green,
                  child: Text('vertical stretched top - bottom  container  '),
                ),
              ) , 
              
              // Negative stretched container toward bottom direction :            
              Positioned( 
                 bottom  : -150 ,
                child:Container(
                  width: 300,
                  height: 100,
                  color: Colors.brown,
                  child: Text('Negative stretched container toward bottom direction   '),
                ),
              ) , 
              

              // this wraping widget will allow to customize position for its child  witin direct parent container [Stack] :
              Positioned(
                left: 0 ,
                child: Text('Shadi'), 
              ),   // [  set the desired location by custom value   ]
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   throw UnimplementedError();
  // }

  //  --------------
}
    

 
//  --------------
    