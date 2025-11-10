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

  22-  [ Appbar]   
   
    => adding a custom Appbar widget to the current screen , and assign some of most popular properties :
        1- leading  : Text("leading"), 
        2- title: Text(" Appbar  widget "),
        3- centerTitle :  true ,
        4- backgroundColor : Colors.red ,
        5- elevation: 1.0 , 
        6- shadowColor: Colors.green ,  
        7- titleTextStyle  :  TextStyle( fontSize:  20 ,fontWeight: FontWeight.boldcolor:Colors.red ),  
        8- actions: [   // assign by certain list of actions(buttons) to be implmented by click on  [represent some  of vip function -usually inlude icon widgets - ]     
            IconButton( onPressed: (){} ,  icon: Icons.list )
            IconButton( onPressed: (){} ,  icon: Icons.menu )
            IconButton( onPressed: (){} ,  icon: Icons.percent  )
          ]
  
 // -----------------------------
 
  23-  [Drawer] :  
    -  drawer: Drawer()  =>  with full peroperites       
    -  endDrawer: endDrawer()  =>  
    -  {iconButton}  -> to control endDrawer => open   function  without the {Appbar}
    -  {iconButton}  -> to control Drawer => open function  without the {Appbar} 
// --------------------------

  24- [Tabbar]  - part 1 -  [current lesson]  
    -  creating (3) {Tab()} inside the  [tabbar]  within  {appbar}     
    -  adding (3) elements children inside  {Tabbarview}  inside the main [container] of body [as simplified contents of ] each page ]   

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

// B- define a new class from  the defined private metod [_MyAppState] :
class _MyAppState extends State<MyApp> {
  // a-  Define  public variables :
  // 1- define a scaffold key variable to be used in controling the drawer withoput need to use [appbar] :
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();

  //-------------------------------------

  // b- using widget building function   :
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: 
      DefaultTabController(
        length: 3, // [the count of the icons inside the tabbar]
        child : Scaffold( 
        // assign the defined [global key] of scaffold  -  to be used to assing cutom   controler     -   :
        key: scaffoldkey,

        // 1- [app bar] of the Home screen :
        appBar: AppBar(
          title:  Text(" tabbar widget - part 1 "), 
          bottom: TabBar(tabs:[
            Tab( child: Text("Labtop")),
            Tab( child: Text("Mobile")),
            Tab( child: Text("PC")) 
          ]),      
        ),

        // 2-  [ Starting default Drawer type] (at left side) :
        drawer: Drawer(
          elevation: 5 ,        
          // shape:  ,
          backgroundColor: Colors.green  ,
          width: 300 ,  
          
          child: Container(
            padding: EdgeInsets.all(15),
            
            // inner content inside of the [drawer]  :
            child: ListView(
              children: [
                //  first main child [ personal profile  icon + title   ]   :
                Row(
                  children: [
                    // first child for [personal image]   :
                    Container(
                      width: 60,
                      height: 60,
                      //  {clipRRect}  to assign custom [border radius] + circular image :
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset(
                          "assets/images/shadi.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // second child for [expanded textual title] :
                    Expanded(
                      child: ListTile(
                        title: Text('Shadi'),
                        subtitle: Text('shadidev@gmail.com'),
                      ),
                    ),
                  ],
                ),

                //  second main child [inner link 1]   :
                ListTile(
                  title: Text('Home Page '),
                  leading: Icon(Icons.home),
                  onTap: () {},
                ),

                //   third  main child [inner link 2]   :
                ListTile(
                  title: Text('Account Page '),
                  leading: Icon(Icons.account_balance_rounded),
                  onTap: () {},
                ),

                //  fourth main child [inner link 3]   :
                ListTile(
                  title: Text('Order Page '),
                  leading: Icon(Icons.check_box),
                  onTap: () {},
                ),

                //  fifth  main child [inner link 4]   :
                ListTile(
                  title: Text('About us Page '),
                  leading: Icon(Icons.help),
                  onTap: () {},
                ),

                // sixth  main child [inner link 5]   :
                ListTile(
                  title: Text('Contact Page '),
                  leading: Icon(Icons.phone_android_outlined),
                  onTap: () {},
                ),

                // seventh  main child [inner link 6]   :
                ListTile(
                  title: Text('Signout Page '),
                  leading: Icon(Icons.exit_to_app),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),

        // 3- [Ending Drawer default type] (at right side) :
        endDrawer: Drawer(),

        // 4- add  floating action button of the main screen :
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('Hello this is the drawer widget  ');
          },
          child: Icon(Icons.add),
        ),

        // 5- assign  Loction of [floatingActionButton] using the [floatingActionButtonLocation] property :
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        // [the main container of the all page ]
        body: Container(
          // [this will set main container with inner padding  to set all its children in full width - instead of setting each widget ]
          padding: EdgeInsets.all(10),

          child: TabBarView( 
          //the added children  must be the same count of assinged  number in the length of scaffold [will be related wit aded tabbars tabs in the main {scaffold}  ]       
           children : [ 
              Text("Laptop page"),  
              Text("Mobile page"),  
              Text("PC page")
          ] ), 
        ),
      ))
      ,
    );
  }

  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   throw UnimplementedError();
  // }

  //  --------------
}
    
 