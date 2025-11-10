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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xfff2f6fb),
        appBar: AppBar(
          title: const Text('First Example [UI Design] - Part 1'),
          centerTitle: true,
          backgroundColor: Colors.blueGrey[700],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔹 First Container
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0xffe6f0fa),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black54, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(40),
                width: double.infinity,
                child: const Text(
                  'First UI Design',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
              ),

              // 🔹 Second Container
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffe6f0fa),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black54, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                width: double.infinity,
                child: const Text(
                  'This is the first UI design course project - part 1.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    height: 1.4,
                  ),
                ),
              ),

              // 🔹 Third Container (Stars & Reviews)
              Container(
                margin: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  color: const Color(0xffe6f0fa),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black54, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star,
                          size: 22,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    const Text(
                      '170 Reviews',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
