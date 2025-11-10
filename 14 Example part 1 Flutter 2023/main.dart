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


  11- [  Example part 1  ] =>  about all previous lessons to implement a UI flutter design using all studied widgets  :
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
           
*/
// --------------------------

// import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('  First example [UI Design]   part 1 ')),
        body: Container(     // [the main container of the  all  page ]
          padding: EdgeInsets.all(10) ,   // [this will set main container with inner padding  to set all its children in full width - instead of setting each widget ] 
           
          child: Column(

            children: [
              // [ First container inside tha main  column ] :   
              Container (
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Color( 0xffe6f0fa),  // [Box background  color]
                  border: Border.all( 
                    color: Colors.black ,     // [ border  Color]
                    width: 2   // [  border width  ]   
                  ),                  
                ),
                padding : EdgeInsets.all(40) , 
                color: Color( 0xffe6f0fa), 
                width: 1000, //  [width greater than mobile scale width]
                child  :   
                  Text (
                    'First UI Design' ,
                     textAlign: TextAlign.center , 
                     style : TextStyle( 
                      fontWeight: FontWeight.w600,
                      color:Colors.grey[700] ,
                      fontSize: 18 , 
                    ),
                  ) , 
              ) ,
        
              // [ Second  container inside tha main  column ] :   
              Container (
                decoration: BoxDecoration(
                  color:  const Color( 0xffe6f0fa),  // [Box background  color]
                  border: Border.all( 
                    color: Colors.black ,     // [ border  Color]
                    width: 2   // [  border width  ]   
                  ),                  
                ),
                padding : const EdgeInsets.symmetric(horizontal: 30 , vertical: 10 ) ,     // [  setting equalled padding wihtin a specified direction  ] 
                color: Color( 0xffe6f0fa), 
                width: 1000, //  [width greater than mobile scale width]
                child  :   
                  Text (
                    'This is the first UI design course project  part 1 ' ,
                     textAlign: TextAlign.center , 
                     style : TextStyle( 
                      // fontWeight: FontWeight.w600,
                      color:Colors.grey[700] ,
                      fontSize: 18 , 
                    ),
                  ) , 
              ) ,
         
              //  [Third container inside tha main column ] : 
              Container (
                margin: const EdgeInsets.only(top : 10 ) ,
                decoration: BoxDecoration(
                  color: const Color( 0xffe6f0fa),  // [Box background  color]
                  border: Border.all( 
                    color: Colors.black ,     // [ border  Color]
                    width: 2   // [  border width  ]   
                  ),                  
                ),
                padding : const  EdgeInsets.symmetric(  horizontal: 40 , vertical: 10 ) ,     // [  setting equalled padding wihtin a specified direction  ] /
                color: Color( 0xffe6f0fa), 
                width: 1000, //  [width greater than mobile scale width to set max width ]
                child :  Row( 
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children : const  [
                     Row (
                      children: [   
                        Icon(Icons.star , size: 20),
                        Icon(Icons.star , size: 20),
                        Icon(Icons.star , size: 20),
                        Icon(Icons.star , size: 20),
                        Icon(Icons.star , size: 20),
                      ],
                    ) , 
                    Text(' 170 Reviews'),
                  ] , 

                )  
                    
              ) ,
         
           ] 

        )),
      ),
    );
  }
}
//  --------------
  