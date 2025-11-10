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
 
  16-  [ Stack ]  =>  
      [ ]  examples =>   
        a- First example [ {Stack} widget description ] =>  [using public & child properites  of  [Stack]  widget  ]   
           
  -----------------------------
  
  17-  [ TextField  ] & [  TextFormField ]  (part 1)  ( current )  =>  
      examples =>   
        a- First example [ (2) {TextField} widget description ] =>  [  appplying some of the properites of {textfield}  ]   
           
  -----------------------------
 

*/
// --------------------------

// import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final fieldStyle = const TextStyle(
    color: Colors.red,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('[TextField] Example')),
        floatingActionButton: FloatingActionButton(
          onPressed: () => print('Hello from FAB'),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: fieldStyle,
                  labelText: 'Username',
                  labelStyle: fieldStyle,
                  prefixIcon: const Icon(Icons.person, color: Colors.lightBlue),
                  suffixIcon: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: fieldStyle,
                  labelText: 'Email',
                  labelStyle: fieldStyle,
                  prefixIcon: const Icon(Icons.mail, color: Colors.lightBlue),
                  suffixIcon: const Icon(Icons.done, color: Colors.green),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
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
    