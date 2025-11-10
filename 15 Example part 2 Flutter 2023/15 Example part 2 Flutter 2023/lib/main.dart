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
  ----------------------- 

  12-  [example part 2] =>
    - complete  designing the  previous application , as following: 
      --  adding new container child [Container ]  wihtin the direct parent container  [column]  -> that will include one container {Row} , which will : 
        --- (3)  [children]  {Column}
        ---  alinging hte inner childner using one olny  of  the  next  methods : 
            a-  [ MainAxisAligment  ] property  of parent  contern   [Row] 
            b-  [ Spacer()] child  widget in-between the inner  children of main  Container  [Row]        
           
*/
// --------------------------

// import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // A helper method for reusable box design
  Widget buildBox(Widget child, {EdgeInsets? padding, EdgeInsets? margin}) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 10),
      padding: padding ?? const EdgeInsets.all(20),
      width: double.infinity, // responsive width
      decoration: BoxDecoration(
        color: const Color(0xffe6f0fa),
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xfff2f5f9),
        appBar: AppBar(
          title: const Text('First Example [UI Design] - Part 2'),
          backgroundColor: Colors.blueGrey[800],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // First Box
              buildBox(
                const Text(
                  'First UI Design',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 18,
                  ),
                ),
              ),

              // Second Box
              buildBox(
                const Text(
                  'This is the first UI design course project (Part 2)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),

              // Third Box (Stars + Reviews)
              buildBox(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.star, size: 24, color: Colors.amber),
                        Icon(Icons.star, size: 24, color: Colors.amber),
                        Icon(Icons.star, size: 24, color: Colors.amber),
                        Icon(Icons.star, size: 24, color: Colors.amber),
                        Icon(Icons.star_half, size: 24, color: Colors.amber),
                      ],
                    ),
                    Text(
                      '170 Reviews',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),

              // Fourth Box (3 Columns)
              buildBox(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    InfoColumn(
                      icon: Icons.person,
                      title: 'Person',
                      value: 'Shadi',
                    ),
                    InfoColumn(
                      icon: Icons.alarm,
                      title: 'Clock',
                      value: '6h 20m',
                    ),
                    InfoColumn(
                      icon: Icons.restaurant,
                      title: 'Feeds',
                      value: '17',
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

// A reusable custom widget for the last row’s columns
class InfoColumn extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoColumn({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.green[700], size: 30),
        const SizedBox(height: 6),
        Text(
          '$title:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}

//  --------------
