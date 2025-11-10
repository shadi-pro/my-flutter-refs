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
  
  17-  [ TextField  ] & [  TextFormField ]  (part 1)  =>  
      examples =>   
        a- First example [ (2) {TextField} widget description ] =>  applying some of the properites of {textfield} of : 
        - [decoration] group properties ->    InputDecoration  -> 
          -- hintText 
          -- hintStyle
          -- labelText
          -- labelStyle
          -- label 
 
          -- prefix          
          -- prefixIcon         
          -- prefixIconColor 
          -- prefixText
          -- prefixStyle 

          -- filled  
          -- filledColor 
          
          -- icon  
          -- iconColor 
            
  -----------------------------
 
  18-  [ TextField  ] & [  TextFormField ]  (part 2) =>  
      examples =>   
        example [ (2) {TextField} widget description ] =>  [  applying some of the properites of {textfield} of  :
          - enabled
          - maxLength 
          - keyboardType:  TextInputType.datatype value 
          - maxLines :  int value  
          - minLines :  int value  
          
          - decoration -> 
            -- border  : OutlineInputBorder || UnderlineInputBorder ->   [type of the border]
            -- focusedBorder : borderSide ||  borderRadius =>  [ textField's border properties of (focus event) for this textField ] 
            -- enabledBorder : borderSide ||  borderRadius =>  [ textField's border properties of (enabled event) for this textField ]  
            -- disbledBorder : borderSide ||  borderRadius =>  [textField's border properties of ( disabled event) for this textField ] 
              
  -----------------------------
  
  19-  [ TextField ]  (part 3) - current => 
      (3) examples =>   
        a- First example [Exp1] =>
          - displaying the value inserted inside the Textfield [ via on click event] -> by using Button's {onPressed()} property to display the defined controller variable    
          - this example including next widgets : 
            1- [(1) {TextField} widget] => will receive the inserted value that will be stored inside the controller assinged defined variable      
            2- [(1) {Button} widget] => the  button will displaying assigned variable of {controller} property of {Textfield}  [ which is the Textfield's inserted value  ]

         b- Second example [Exp2] =>
          - displaying the value inserted inside the Textfield [via on Change event - live change -] -> using Button's {onChange()} property to display the defined controller variable [in console]    
          - this example including next widgets : 
            1- [(1) {TextField} widget] => will receive the inserted value that will be stored inside the controller assinged defined variable      
            2- [(1) {Button} widget] => the  button will displaying assigned variable of {controller} property of {Textfield}  [ which is the Textfield's inserted value  ]

        c- Third example [Exp3] =>
          - displaying the value inserted inside the Textfield [via on Change event - live change -] -> using Button's {onChange()} property to display the defined controller variable in [Text Widget]   
          - this ecxample including next widgets : 
            1- [(1) {TextField} widget] => will receive the inserted value that will be stored inside the controller assinged defined variable      
            2- [(1) {Button} widget] => the  button will displaying assigned variable of {controller} property of {Textfield}  [ which is the Textfield's inserted value  ]

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
  // a-  define  public variables :
    // 1- [Exp1] :  define the controller variable of [TextEditingController] datatype :   
    TextEditingController  username = TextEditingController();

    // 2- [Exp2] & [Exp3] :  : define an empty variable to be assigned by [onChanged()] paramter value  +  display within console +Text widget :
    String? textVal;

  //-------------------------------------

  // b- using widget building function   :
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // app bar of the main screen :
        appBar: AppBar(title: const Text(' [TextField]  widget part 3 ')),

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
              
              // first default text field [Username] :
              TextField(
                // [Exp1] : assign the defined controller variable by the controller's value (the textfield content value )   :
                controller: username,

                // [Exp2] : this function property will execute the action of (display the value inserted inside [textfield]) once the textfield changed  :
                onChanged: (val) {
                  // [ assign defined variable by the parmenter value (val) that represent the textfield cotnent value + using (setState) for live change of defined varaible {textVal} 
                  setState(() {
                    textVal = val; 
                  });
                },

                decoration: InputDecoration(
                  hintText: 'username', // the place holder text
                  hintStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                  ), // [the formating properties for  {hintText} ]
                  labelText:
                      'Username', // [place holder & label text with auto subtitling effect]
                  labelStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                  ), // [ the formating properties for  {labelText}]
                  label: Text(
                    // [  alternative of LabelText or hintText ]
                    'Username',
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ),

                  prefix: Icon(
                    Icons.person,
                  ), //  [a widget before textfield (accept any widget , but commonly an icon) ]
                  prefixIcon: Icon(
                    Icons.person,
                  ), // [a specfic iconic widget before textfield ]
                  prefixIconColor:
                      Colors
                          .lightBlue, // [a specfic iconic widget before textfield ]
                  prefixText:
                      'username : ', // [a specfic texual widget before textfield - can not be removed when writing by user  - ]
                  prefixStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ), // [ formtating property for the {prefixText} ]

                  suffix: Icon(
                    Icons.person,
                  ), //  [an widget after textfield (accept any widget , but commonly an icon) ]
                  suffixIcon: Icon(
                    Icons.person,
                  ), // [a specfic iconic widget after  textfield ]
                  suffixIconColor:
                      Colors
                          .lightBlue, // [a specfic iconic widget before textfield ]
                  suffixText:
                      ' username', // [a specfic texual widget after textfield - can not be removed when writing by user - ]
                  suffixStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ), // [ formtating property for the {suffixText} ]

                  filled:
                      true, // [ required for  activating the  'fillcolor'  ]
                  fillColor: Colors.grey, // [ textField background color  ]

                  icon: Icon(
                    Icons.person,
                  ), // [ icon before the textfiled [not a prefix icon]  ]
                  iconColor: Colors.blue, // [ icon  color ]
                ),
              ),

              Spacer(),

              // [Exp1] : button to display the value inserted inside the [textfield] by click on this button using the stored value of [controller] :
              MaterialButton(
                onPressed: () {
                  // printing textField value using stored value inside the defined variable of [username] -  printing inside console -  :
                  print(username.text);
                },
                child: Text("Click to print textfield value of Controller"),
                color: Colors.red,
                textColor: Colors.white,
              ),


              // [Exp2] : button to display the value inserted inside the [textfield]  by click on this button using the stored value of  [onChange(value)] functional parameter property    :
              MaterialButton(
                onPressed: () {
                  print('===========================') ;  
                  print(textVal) ;  // printing textField value represented by stored value inside the defined dynamic variable of [ textVal ] (printing inside the console) :
                },
                child: Text("Click to print textfield value of onChange"),
                color: Colors.red,
                textColor: Colors.white,
              ),

              // [Exp3] : using a {Text} Widget  for live  display of dynamic variable of [textVal] :
              Text("$textVal")   // printing textField value represented by stored value inside the defined dynamic variable of [ textVal ] (printing inside the  Text widget) : 
 
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
    