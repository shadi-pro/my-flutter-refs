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
 
  14-  [ Radio ] &  [ RadioListTile ] ( current )  =>  
      [2]  examples =>   
        a- [widget description - choose your country ] => using  a string value for Radio value  + {setState} for live responding       
        b- [widget description - choose your age ]  => using  a intger value for Radio value  + {setState} for live responding       
         
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
  // a-  define  public variables 'first example'  :
  // 1-  define  public variables 'first example'  :
  String? country = 'Egypt'; //[the groupValue  variable for  'first example' ]

  // 2-  define  public variables 'second example'  :
  int? age = 0;  //[the groupValue  variable for  'second example' ]

  // b- using widget building function   :
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // app bar of the main screen :
        appBar: AppBar(title: const Text('  StatefulWidget & setStatue  ')),

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
          padding: EdgeInsets.all( 10 ), // [this will set main container with inner padding  to set all its children in full width - instead of setting each widget ]

          child: Column(
            children: [
              // 1- First example  [choose your country] :
              //  default Radio button  :
              Radio(
                //  1-  'value' -> [ the status value of the {Switch} button ] :
                value:
                    'Egypt', // [ assign a defined varible for value property  dynamic change    ]
                // 2- 'onChanged' -> [a method to assgin a inner procedures  to be implemented  when  changing the radio button  ] :
                onChanged: (val) {
                  // [ val => represent the current  status value of this radio button ]
                  print('  you switched the button   ');

                  setState(() {
                    country =
                        val; //  [re-assign   [ country] varilble by onChanged  parameter variable  to execute the live changeing ]
                  });
                },

                // 3- [groupValue] property   :
                groupValue: country,

                // 4- assign the radio's ball  color in [active case] :
                activeColor: Colors.blue,
              ),

              // ------------------------------
              Spacer(),

              Text(' Choose  your  country :  '),

              // First example / first  [RadioListTile]  :
              RadioListTile(
                //  1- [status value of the {Radio} button    ]  :
                title: Text('Egypt :'),

                // 2- assign the Radio's background color :
                tileColor: Colors.yellow,

                // 3- [status value of the {Radio} button    ]  :
                value:
                    'Egypt', // [ assign a defined varible for value property  dynamic change  ]
                // 4- [assgin a inner  procedures  to be implemented by selecting  the Radio button  ] :
                onChanged: (val) {
                  // [ val => represent the current value of this radio button - if selected  ]
                  print('  you choosed ${val} button   ');

                  setState(() {
                    // assign the [groupValue 's defined variable ] by this radio's [onChanged parameter] value  :
                    country =
                        val; // => [ to make the current radio value is the main group value - in live   ]
                  });
                },

                // 5- [groupValue] property   :
                groupValue: country,

                // 6- assign the Radio's ball  color in [active case] :
                activeColor: Colors.blue,

                // 7-  assign a custom padding to this radio button     :
                contentPadding: EdgeInsets.all(10),
              ),

              // First example / second [RadioListTile]  :
              RadioListTile(
                //  1- [status value of the {Radio} button    ]  :
                title: Text('Syria :'),

                // 2- assign the Radio's background color  :
                tileColor: Colors.blue,

                //  2- [status value of the {Radio} button    ]  :
                value:
                    'Syria', // [ assign a defined varible for value property  dynamic change  ]
                // 3- [assgin a inner  procedures  to be impolemented by changing the Radio button  ] :
                onChanged: (val) {
                  // [ val => represent the current  value of this radio button - if selected   ]
                  print('  you choosed on ${val} button   ');

                  setState(() {
                    //  assign the [groupValue] by this radio's [onChanged parameter] value  :
                    country =
                        val; // => [ to make the current radio value is the main group value - in live ]
                  });
                },

                // 4- [groupValue] property   :
                groupValue: country,

                // 5- assign the Radio's ball  color in [active case] :
                activeColor: Colors.blue,

                // 6-  assign a custom padding to this radio button     :
                contentPadding: EdgeInsets.all(10),
              ),

              // First example / third  [RadioListTile] :
              RadioListTile(
                //  1- [status value of the {Radio} button    ]  :
                title: Text('Palastine :'),

                // 2- assign the Radio's background color  :
                tileColor: Colors.blue,

                // 3- [status value of the {Radio} button    ]  :
                value:
                    'Palastine', // [ assign a defined varible for value property  dynamic change  ]
                // 4- [assgin a inner  procedures  to be impolemented by changing the Radio button  ] :
                onChanged: (val) {
                  // [ val => represent the current value of this radio button - if selected  ]
                  print('  you choosed on  ${val} button ');

                  setState(() {
                    //  assign the [groupValue] by this radio's [onChanged parameter] value  :
                    country =
                        val; // => [ to make the current radio value is the main group value - on live  ]
                  });
                },

                // 5- [groupValue] property   :
                groupValue: country,

                // 6- assign the Radio's ball  color in [active case] :
                activeColor: Colors.blue,

                // 7-  assign a custom padding to this radio button     :
                contentPadding: EdgeInsets.all(10),
              ),

            // printing the [country] varialbe  after is being re-assigned by the selected   RadioListTile   :
              Text(
                'you choosed :  ${country} ' , 
                style : TextStyle( fontSize:20 , color : Colors.green , fontWeight:  FontWeight.bold ) ,   
              ),

              Spacer(),
              Spacer(),

              // 2- Second Examples [choose your age ] :
              Text(' Choose you age : '),

              // Second  example / first RadioListTile :
              RadioListTile(
                title: Text('20'),
                value: 20,

                groupValue: age,

                onChanged: (val) {
                  setState(() {
                    age = val;
                  });
                },
              ),

              // Second  example / second RadioListTile :
              RadioListTile(
                title: Text('25'),
                value: 25,

                groupValue: age,

                onChanged: (val) {
                  setState(() {
                    age = val;
                  });
                },
              ),

              // Second  example / third RadioListTile :
              RadioListTile(
                title: Text('30'),
                value: 30,

                groupValue: age,

                onChanged: (val) {
                  setState(() {
                    age = val;
                  });
                },
              ),

            // printing the [age] variable  after is being re-assigned by the selected   RadioListTile   :
              Text(
                'you choosed :  ${age} ' , 
                style : TextStyle( fontSize:20 , color : Colors.green ,  fontWeight:  FontWeight.bold ) ,   
              ),
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
    