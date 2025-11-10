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
  // ----------------------
  

  10- [ Expanded  ]   Widget   => this lesson  :   
     
    
  // ----------------------
  
   // This app descrption   :
      - design a main container of [Container]  , as the next structure : 

        -- Main Parent container  [Row || Column  ]    => to include (3) [Expanded]  of child of  container type   of differnet  values of {flex } :
           
           
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
        appBar: AppBar(title: const Text('  [ Expanded ] widget  ')),

        //  Main Parent Container  :
        body: Container(
          child:  Row(
            children : [
              Expanded(
                child: Container (  color : Colors.red , height: 100  ), 
                flex : 1 ,  // the default value  of the flex    
              ) , 
               
              Expanded(
                child: Container (  color : Colors.red , height: 100  ), 
                flex : 2 ,  // [ the  doubled width of the other expanded  child      
              ) , 
               
              Expanded(
                child: Container (  color : Colors.red , height: 100  ), 
                flex : 3 ,  //    [the trible  width of the other expanded  child      
              ) , 
               
            ] ,
          )   
          
          
          // child:  Column(
          //   children : [
          //     Expanded(
          //       child: Container (  color : Colors.red , width: 100  ), 
          //       flex : 1 ,  // the default height  value  of the flex    
          //     ) , 
               
          //     Expanded(
          //       child: Container (  color : Colors.red , width: 100  ), 
          //       flex : 2 ,  // [ the  doubled height of the other expanded  child      
          //     ) , 
               
          //     Expanded(
          //       child: Container (  color : Colors.red ,  width: 100  ), 
          //       flex : 3 ,  //    [the trible  height of the other expanded  child      
          //     ) , 
               
          //   ] ,
          // )   


        ),
      ),
    );
  }
}
//  --------------
  