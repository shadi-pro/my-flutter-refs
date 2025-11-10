/*
 Lessons applied in this application :  
   1- [Text] widget
   2- [Container] widget

*/
// --------------------------

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
        appBar: AppBar(title: const Text('Shadi App')),
        body: Container(
          width: 500,
          height: 1000,
          // alignment: Alignment.center, // [ aligments of its children of center of both axises , but can be assigned with more specific alignment values : (topRight , topLeft , bottomRight , bottomLeft )   ]
          alignment: Alignment
              .center, // [ aligments of its children of center of both axises , but can be assigned with more specific alignment values : (topRight , topLeft , bottomRight , bottomLeft )   ]
          padding: EdgeInsets.all(10), // [ padding with all directions ]
          margin: EdgeInsets.all(20), // [ margin with all directions ]

          decoration: BoxDecoration(
            color: Colors
                .red, // [ container color , but must be inside the BoxDecoration if it existed  ]
            // borderRadius: BorderRadius.all(Radius.circular(10) ) ,  // [one of decoratoin properties]
            borderRadius: BorderRadius.all(
              Radius.circular(1000),
            ), //  [large value of the circular will form a full circle - but the height must = width - ]

            border: Border.all(
              color: Colors.brown,
              width: 3,
            ), // [Border accepts several properites]

            boxShadow: [
              // [ this property can hold several of [BoxShadow] widgets ]
              BoxShadow(
                // [first boxShadow]
                color: Colors.blue,
                offset: Offset(5, 2),
                spreadRadius: 5,
                blurRadius: 10,
              ),

              BoxShadow(
                // [second boxShadow]
                color: Colors.green,
                offset: Offset(-5, -2),
                spreadRadius: 5,
                blurRadius: 10,
              ),
            ],
          ),

          child: const Text(
            "Shadi Mob App", // [The value proerty of Text Widget]
            style: TextStyle(
              // [ The style property is using the {TextStyle} widget ]
              color: Colors.white,

              // color: Color(0xff9d391d) , // [or Color(color Hexa Code 0xff### )]
              // color: Colors.pink[700] , // [or Color(color Hexa Code 0xff### )]
              // color: Color.fromARGB(255, 136, 54, 172)  , // [or Color(color Hexa Code 0xff### )]
              fontSize: 40,

              // fontWeight: FontWeight.bold,
              fontWeight: FontWeight.w600,

              // backgroundColor: Colors.blue,

              // fontFamily : '',
            ),
          ),
        ),
      ),
    );
  }
}
