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
 
  15-  [ Checkbox ] &  [ CheckboxListTile ] ( current )  =>  
      [2]  examples =>   
        a- First example [ {Checkbox} widget description ] =>  [using {checkbox}  + {Text} widget]  {hobby choosing} 
        b- Second example [ {CheckboxListTile} widget description ] =>  [using { CheckboxListTile}  widget]  { languages choosing} 
          
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

  // 1-  define  public variables 'first example'  :
  bool? status = false; //[ the Value property in the 'first example' ]

  // 2-  define  public variables 'second example'  :
  bool? arabic =
      false; //[ the Value property of the first choise in 'second example' ]

  bool? english =
      false; //[ the Value property of the  second choise in 'second example' ]

  bool? frensh =
      false; //[ the Value property of the third choise in 'second example' ]

  bool? german =
      false; //[ the Value property of the forth choise in 'second example' ]
  //-------------------------------------

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
          padding: EdgeInsets.all(
            10,
          ), // [this will set main container with inner padding  to set all its children in full width - instead of setting each widget ]

          child: Column(
            children: [
              //  First example [using {checkbox}  + {Text} widget]  {hobby choosing} 0:
              Text('First example / Choose your hobby : '),
              Spacer(),

              // 1- Swimming Choice :
              Text(' Swimming '),

              // Default checkbox button  :
              Checkbox(
                //  1-  'value' -> [ the status value of the {Checkbox} button ] :
                value:
                    status, // [ assign a simple boolean value OR defined variable ]
                // 2- 'onChanged' -> [a method to assgin a inner procedures  to be implemented  when  changing the checkbox   ] :
                onChanged: (val) {
                  // [ val => represent the current  status value of this checkbox  ]
                  print(val);

                  setState(() {
                    status =
                        val!; //  [re-assign  [status] variable by onChanged parameter's variable  to execute the live changing ]
                  });
                },

                // 3- assign the checkbox   color in [active case] :
                activeColor: Colors.blue,
              ),

              Spacer(),

              // 2- Football Choice :
              Text(' Football '),

              // Default checkbox button  :
              Checkbox(
                //  1-  'value' -> [ the status value of the {Checkbox} button ] :
                value:
                    status, // [ assign a simple boolean value OR defined variable ]
                // 2- 'onChanged' -> [a method to assgin a inner procedures  to be implemented  when  changing the checkbox   ] :
                onChanged: (val) {
                  // [ val => represent the current  status value of this checkbox  ]
                  print(val);

                  setState(() {
                    status =
                        val!; //  [re-assign  [status] variable by onChanged parameter's variable  to execute the live changing ]
                  });
                },

                // 3- assign the checkbox   color in [active case] :
                activeColor: Colors.blue,
              ),

              Spacer(),

              // 3- Handball Choice :
              Text(' Handball '),

              // Default checkbox button  :
              Checkbox(
                //  1-  'value' -> [ the status value of the {Checkbox} button ] :
                value:
                    status, // [ assign a simple boolean value OR defined variable ]
                // 2- 'onChanged' -> [a method to assgin a inner procedures  to be implemented  when  changing the checkbox   ] :
                onChanged: (val) {
                  // [ val => represent the current  status value of this checkbox  ]
                  print(val);

                  setState(() {
                    status =
                        val!; //  [re-assign  [status] variable by onChanged parameter's variable  to execute the live changing ]
                  });
                },

                // 3- assign the checkbox   color in [active case] :
                activeColor: Colors.blue,
              ),

              Spacer(),
              Spacer(),

              // ------------------------------
              Text(' Second  example / Choose  your language  :  '),

              // Second  example / [using {CheckboxListTile} ]   :

              // 1- choise [Arabic] :
              CheckboxListTile(
                //  1- [title  value of the {CheckboxListTile} ]  :
                title: Text(' Arabic :'),

                // 2- assign the CheckboxListTile's background color :
                tileColor: Colors.yellow,

                // 3- [ value of the {CheckboxListTile} button ]  :
                value:
                    arabic, // [ assign a defined variable for value property ]
                // 4- [assgin inner  procedures  to be implemented by selecting  this CheckboxListTile ] :
                onChanged: (val) {
                  // [ val => represent the current value of this CheckboxListTile - if selected  ]
                  print(val);

                  setState(() {
                    // assign the [groupValue 's defined variable ] by this radio's [onChanged parameter] value  :
                    arabic =
                        val!; // => [ to make the current radio value is the main group value - in live   ]
                  });
                },

                // 5- assign the Checkbox  color in [active case] :
                activeColor: Colors.blue,

                // 6- assign the Check mark color in [active case] :
                checkColor: Colors.red,

                // 7-  assign a custom padding to this checkbox     :
                contentPadding: EdgeInsets.all(10),
              ),

              // 2- choise [English] :
              CheckboxListTile(
                //  1- [title  value of the {CheckboxListTile} ]  :
                title: Text('English :'),

                // 2- assign the CheckboxListTile's background color :
                tileColor: Colors.yellow,

                // 3- [ value of the {CheckboxListTile} button ]  :
                value:
                    english, // [ assign a defined variable for value property ]
                // 4- [assgin inner  procedures  to be implemented by selecting  this CheckboxListTile ] :
                onChanged: (val) {
                  // [ val => represent the current value of this CheckboxListTile - if selected  ]
                  print(val);

                  setState(() {
                    // assign the [groupValue 's defined variable ] by this radio's [onChanged parameter] value  :
                    english =
                        val!; // => [ to make the current radio value is the main group value - in live   ]
                  });
                },

                // 5- assign the Checkbox  color in [active case] :
                activeColor: Colors.blue,

                // 6- assign the Check mark color in [active case] :
                checkColor: Colors.red,

                // 7-  assign a custom padding to this checkbox     :
                contentPadding: EdgeInsets.all(10),
              ),

              // 3- choise [Frensh] :
              CheckboxListTile(
                //  1- [title  value of the {CheckboxListTile} ]  :
                title: Text(' Frensh :'),

                // 2- assign the CheckboxListTile's background color :
                tileColor: Colors.yellow,

                // 3- [ value of the {CheckboxListTile} button ]  :
                value:
                    frensh, // [ assign a defined variable for value property ]
                // 4- [assgin inner  procedures  to be implemented by selecting  this CheckboxListTile ] :
                onChanged: (val) {
                  // [ val => represent the current value of this CheckboxListTile - if selected  ]
                  print(val);

                  setState(() {
                    // assign the [groupValue 's defined variable ] by this radio's [onChanged parameter] value  :
                    frensh =
                        val!; // => [ to make the current radio value is the main group value - in live   ]
                  });
                },

                // 5- assign the Checkbox  color in [active case] :
                activeColor: Colors.blue,

                // 6- assign the Check mark color in [active case] :
                checkColor: Colors.red,

                // 7-  assign a custom padding to this checkbox     :
                contentPadding: EdgeInsets.all(10),
              ),

              // 4- choise [ German] :
              CheckboxListTile(
                //  1- [title  value of the {CheckboxListTile} ]  :
                title: Text(' German :'),

                // 2- assign the CheckboxListTile's background color :
                tileColor: Colors.yellow,

                // 3- [ value of the {CheckboxListTile} button ]  :
                value:
                    german, // [ assign a defined variable for value property ]
                // 4- [assgin inner  procedures  to be implemented by selecting  this CheckboxListTile ] :
                onChanged: (val) {
                  // [ val => represent the current value of this CheckboxListTile - if selected  ]
                  print(val);

                  setState(() {
                    // assign the [groupValue 's defined variable ] by this radio's [onChanged parameter] value  :
                    german =
                        val!; // => [ to make the current radio value is the main group value - in live   ]
                  });
                },

                // 5- assign the Checkbox  color in [active case] :
                activeColor: Colors.blue,

                // 6- assign the Check mark color in [active case] :
                checkColor: Colors.red,

                // 7-  assign a custom padding to this checkbox     :
                contentPadding: EdgeInsets.all(10),
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
    