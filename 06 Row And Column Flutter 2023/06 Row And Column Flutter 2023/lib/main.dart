/*
 Lessons applied in this application :  
   1- [Text] widget 
   2- [Container]  widget 
   3- [Image] widget
   4- [Column] & [Row] widget => this lesson     [3:35]  

   // app descrption   :
      -- design  one column insisde the main coinntiner , and this column will include seveeral rows of  , each row inolcude sefveral containers    

      - Container : 
        -- Column : 
          --- Rows[ 6 ] : (  each  row has specific main axis alignment of its Childnren : [  ] )
            ---- Containers[3]   
*/
// --------------------------

// import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('[Column] & [Row] widget')),
        body: Container(
          // [ the main container of the whole  app  ]
          width: 800,
          height: 1000,
          child: Column(
            // a- properties of [column] :
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceEvenly, // [ main axe of column [vertical] alignment ]
            crossAxisAlignment:
                CrossAxisAlignment
                    .center, // [ cross axe of column [Horizonal] alignment ]
            // b- children of the [column]  :
            children: [
              // [ Row 1 : include list of children containers widgets , with main axis aligment:  [spaceBetween] ] :
              Text(
                'Row 1 : with  main axis aligment:  [spaceBetween] ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  // border: Border.all()
                ),
              ),

              Row(
                // a- properties of [Row 1] :
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween, // [ main axe of column [vertical] alignment , with available optiosn    : [center,start , end ,  spaceEvenly , spaceBetween , spaceAround  ]
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start, // [ cross axe of column [Horizonal] alignment ]
                // b- children of the row 1  :
                children: [
                  // the first container inside the row 1 :
                  Container(width: 100, height: 50, color: Colors.blue), //
                  // the second  container inside the row 1 :
                  Container(width: 100, height: 50, color: Colors.red), //
                  // the third  container inside the row 1 :
                  Container(width: 100, height: 50, color: Colors.green), //
                ],
              ),
              // ----------------------------------

              // [ Row 2 : include list of children containers widgets , with main axis aligment:  [spaceEvenly] ] :
              Text(
                'Row 2 : with  main axis aligment:  [spaceEvenly] ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              Row(
                // a- properties of [Row 2] :
                // [ main axe of column [vertical] alignment : [center,start , end ,  spaceEvenly , spaceBetween , spaceAround  ]
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start, // [ cross axe of column [Horizonal] alignment ]
                // b- children of the row 2  :
                children: [
                  // the first container inside the row 2 :
                  Container(width: 100, height: 50, color: Colors.blue), //
                  // the second  container inside the row 2 :
                  Container(width: 100, height: 50, color: Colors.red), //
                  // the third  container inside the row 2 :
                  Container(width: 100, height: 50, color: Colors.green), //
                ],
              ),

              // ---------------------------

              // [ Row 3 : include list of children containers widgets , with main axis aligment:  [ spaceAround] ] :
              Text(
                'Row 3 : with  main axis aligment:  [spaceAround] ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              Row(
                // a- properties of [Row 3] :
                // [ main axe of column [vertical] alignment : [center,start , end ,  spaceEvenly , spaceBetween , spaceAround  ]
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start, // [ cross axe of column [Horizonal] alignment ]
                // b- children of the row 3  :
                children: [
                  // the first container inside the row 3 :
                  Container(width: 100, height: 50, color: Colors.blue), //
                  // the second  container inside the row 3 :
                  Container(width: 100, height: 50, color: Colors.red), //
                  // the third  container inside the row 3 :
                  Container(width: 100, height: 50, color: Colors.green), //
                ],
              ),

              // ----------------------

              // [ Row 4 : include list of children containers widgets , with main axis aligment:  [ center ] ] :
              Text(
                'Row 4 : with  main axis aligment:  [center] ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              Row(
                // a- properties of [Row 4] :
                // [ main axe of column [vertical] alignment : [center,start , end ,  spaceEvenly , spaceBetween , spaceAround  ]
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start, // [ cross axe of column [Horizonal] alignment ]
                // b- children of the row 4 :
                children: [
                  // the first container inside the row 3 :
                  Container(width: 100, height: 50, color: Colors.blue), //
                  // the second  container inside the row 3 :
                  Container(width: 100, height: 50, color: Colors.red), //
                  // the third  container inside the row 3 :
                  Container(width: 100, height: 50, color: Colors.green), //
                ],
              ),

              // ----------------------

              // [ Row 5 : include list of children containers widgets , with main axis aligment:  [ end  ] ] :
              Text(
                'Row 5 : with  main axis aligment:  [ end ] ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              Row(
                // a- properties of [Row 5] :
                // [ main axe of column [vertical] alignment : [center,start , end ,  spaceEvenly , spaceBetween , spaceAround  ]
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start, // [ cross axe of column [Horizonal] alignment ]
                // b- children of the row 5 :
                children: [
                  // the first container inside the row 5 :
                  Container(width: 100, height: 50, color: Colors.blue), //
                  // the second  container inside the row 3 :
                  Container(width: 100, height: 50, color: Colors.red), //
                  // the third  container inside the row 3 :
                  Container(width: 100, height: 50, color: Colors.green), //
                ],
              ),

              // ----------------------------------

              // [ Row 6 : include list of children containers widgets , with main axis aligment:  [ Start   ] ] :
              Text(
                'Row 6 : with  main axis aligment:  [ start ] ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              Row(
                // a- properties of [Row 6] :
                // [ main axe of column [vertical] alignment : [center,start , end ,  spaceEvenly , spaceBetween , spaceAround  ]
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start, // [ cross axe of column [Horizonal] alignment ]
                // b- children of the row 6 :
                children: [
                  // the first container inside the row 6 :
                  Container(width: 100, height: 50, color: Colors.blue), //
                  // the second  container inside the row 3 :
                  Container(width: 100, height: 50, color: Colors.red), //
                  // the third  container inside the row 3 :
                  Container(width: 100, height: 50, color: Colors.green), //
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
