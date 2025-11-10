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
  
  19-  [ TextField ]  (part 3) -  
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
  
  20-  [ TextFormField ]  (part 2 - onSaved ) - 
       (1) examples =>   
         First example [Exp1] =>
          a - main processes :  
           1- vaidation process  =>  
            -- [assign valdiation logics] :  using [validator] property method of a the [textformfield] to assign the valdiatoin  logics       
            -- [activation of validatoin logics ] : using [validate()] in seprated button'event property in the same Form,  with defined form key to activate the assigned valdiatoins  logics           
           
           
           2- saving process   => 
            -- [assign inserted value ] :  using [onSaved] of [TextFormField] to assing the inserted field value into the predfined varlable  
            -- [ activation of the save process   ] : using [save()] of in seprated button'event property in the same Form,  with defined form key to activate the assigned  saved value in the onSaved   

          
          b - implementing assigned logics of all   {TextFormField} inside the Form , by using a one submit button  {MaterialButton}
          - this example including next widgets : 
            1- [(2) {TextFormField} widget] =>  each will include : 
              - saved textformfield using [ onSaved ] functional property for each textformField + predefined specefied variable        
              - several [ validation logics ] including    : 
                --  inserted amount empty + limitations  
                 
            2- [(1) {Button} widget] => the button will execute assigned [validaton logic]  of all textFormField : 
              - assigning onPressed property by   conditional executing of assigned validations logics for th current textformfiled   
              - actvating the {save()} of [onSaved] incase of validations is true  
  -----------------------------
  
 
  21-  [ TextFormField ]  (part 3 -  autovalidate  ) 

    a - determining  public [autovalidateMode]  within the [Form] the parent container of the all   (inner  textformfields)     of certain type  (for all inner textformfields)  :
    b - determining  private [autovalidateMode] of certain type  (for  this textformfield only  )  :

 // -----------------------------



  22-  [ Appbar]  -  [current] 
   
    a-         
  

 // -----------------------------
 

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
  // a-  Define  public variables :
  // 1- Define the [Form key] variable to be used inside the key property of the [Form] as an extracted varialbe from the [GlobalKey()]    :
  GlobalKey<FormState> formstate = GlobalKey();

  // 2- Define public variables for each username & phone [textformfiled](s)    :
  String? username;
  String? phone;

  //-------------------------------------

  // b- using widget building function   :
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // app bar of the main screen :
        appBar: AppBar(
          title: const Text(' [TextFormField]  widget part 2 :  onSaved   '),
        ),

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

          child: Form(
            /// determining  public [autovalidateMode] of {onUnfocus} type  (for all inner textformfields  )  :
            autovalidateMode: AutovalidateMode.onUnfocus,
            
            key:
                formstate, // [ assign the defined [formstate] variable of the GlobalKey datatype       ]
            child: Column(
              children: [
                // First  TextFormField [username]  :
                TextFormField(
                  // determining a private [autovalidatemode]  for this textformfield :       
                  autovalidateMode: AutovalidateMode.always ,
                  // autovalidateMode: AutovalidateMode.values,                  
                  // autovalidateMode: AutovalidateMode.onUnfocus,                  
                  // autovalidateMode: AutovalidateMode.disabled,                  
                                     
                  // the (val) paramter is holding the saved value ofthis [TextFormField : username]
                  onSaved: (val) {
                    username =
                        val; // [assign the [saved value (val)] to predfined variable of [username]  ]
                  },

                  decoration: InputDecoration(hintText: "username"),

                  validator: (value) {
                    // [ assigned logic(s) ]  of validation process  ( to be executed when validation process of {validator} functional  property is beign called   ) :

                    // first validation logic [ can not accept empty value ]   :
                    if (value!.isEmpty) {
                      return 'الحقل فارغ';
                    }

                    // second validation logic [can not accept less than 3 letters ]  :
                    if (value.length < 3) {
                      return 'لا تقبل القيمة المدخلة افل من 3 ';
                    }

                    // third  validation logic [can not accept  greater  than 20 letters ]  :
                    if (value.length > 20) {
                      return 'لا تقبل القيمة المدخلة اكبر من 20 ';
                    }
                  },
                ),

                // Second TextFormField [phone ] :
                TextFormField(
                  // the (val) paramter is holding the saved value ofthis [TextFormField : phone]
                  onSaved: (val) {
                    phone =
                        val; // [assign the [saved value (val)] to predfined variable of [phone]  ]
                  },

                  decoration: InputDecoration(hintText: "phone"),

                  validator: (value) {
                    // [ assigned logic(s) ]  of validation process  ( to be executed when validation process of {validator} functional  property is beign called   ) :

                    // first validation login  [can not accept empty value ]  :
                    if (value!.isEmpty) {
                      return 'الحقل فارغ';
                    }

                    // second validation logic [can not accept larger than 10 numbers ]     :
                    if (value.length > 12) {
                      return 'لا تقبل القيمة المدخلة اكبر من 12 ';
                    }

                    //  Third validation logic [can not accept  less than 3 numbers ]     :
                    if (value.length < 9) {
                      return 'لا تقبل القيمة المدخلة اقل من 9 ';
                    }
                  },
                ),

                //  a submit Button to call the defined validations of each upper [textformfield] by using  [ assigned  variable inside the [key] property of thre main {Form}   ]       :
                MaterialButton(
                  child: Text("Valid"),
                  color: Colors.white,
                  textColor: Colors.red,

                  //  this method will use/call  [validator] property of the [textformfield] to implement the assgined function once this button is pressed   :
                  onPressed: () {
                    
                    // [validation  process ] :
                    // [ if the  textformfield's content is valid through the assingned logical validations - all assigned validations logics are matched   ]
                    if (formstate.currentState!.validate()) {
                      // [ saving   process ] :
                      // calling {onSaved} of this textformfield =>  to activate saving the inserted value inside the [onSaved] parameter of the current textformField  :
                      formstate.currentState!.save();
                      print('valid');

                    } else {
                      // [ if the  textformfield's content is Not valid through the assingned logical validations - one more  not matching all assigned validations logics) content is Not valid  ]
                      print('Not valid');
                    }
                  },
                ),
              ],
            ),
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
    