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
 -
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

  24- [Tabbar]  - part 1 -   
    -  creating (3) {Tab()} inside the  [tabbar]  within  {appbar}     
    -  adding (3) elements children inside  {Tabbarview}  inside the main [container] of body [as simplified contents of ] each page ]   
// -------------------------------------------
  25- [Tabbar]  - part 2 -  : 
    - use the custom method to define and control the {Tabbar}  instead of default method {defaultTabContoller} , as following ;
      a- using  with  {SingleTickerProviderStateMixin} to define {private method [_MyAppState]} class 
      b- Define global custom  function {initState} to be executed once the screen is opened , which will assign the value of [tabController]  empty variable by {TabController} method wit desired length of tabs     
      c- define variable {tabController} with datatype {TabController} with empty value
      d- assign [controller]  property with defined  [tabController] as it's value , in both of [{Tabbar} - witin (Scaffold) ]  & [ {TabBarView} - within  (body) container ] 
      e- create a button to naviagte/animate to a certain page -> [  as extracted  from  defined custom controller  property [tabController]  ]      
        

  // --------------------------

  26- [BottomNavigationBar]  : 
     -   using {BottomNavigationBar}   to navigate  through custom defined [list] variable of pages      


  // --------------------------
  
  27- [ Pageview] & [PageViewbuilder]  : 
     - [Pageview]  ->  creating fixed  horizontal slider using fixed  children  of widgets     
     - [Pageview.builder()]   ->  creating dynamic horizontal slider using  item of defined list variable of widgets or values    
  // --------------------------

  28- [ CustomWidget ]     : 
     -  creating shorcut custom widget imported from another file        

  // --------------------------
 
 
  29- [ Navigator ]  : 
    -  using  [Navigator] method to set navigaion tool inside iner pages , as button onPassed property 

  // --------------------------


  30-  {Push} and {PushReplacement}  types of {navigaion()}       : 
    -  using  {Push} and {PushReplacement} types  to set  advanced navigation  control as next :  
      a-  navgiate to inner page [about] using  [.push() ]    
      b-  navgiate to inner page [ .pushPushReplacement()] using  [.push() ]    
     
  // --------------------------

 
  31-  {.pop(} type of {navigaion()} method  : 
    -  using {.pop()} {.push} and {.pushReplacement} navigation types methods   to set  advanced navigation  control as next :  
      a-  navgiate to inner page [about] using  [.push() ]    
      b-  navgiate to inner page [ .pushPushReplacement()] using  [.push() ]    
      c-  navgiate to go back using   [ .pop()]  
     

  // --------------------------

    32-   Navigator with Routes method  : 
        a-  using navigator with   {.PushRemoveUntil()}  
        b-  using 'routes'  inside {main.dart} => to set all roeus in the project    
   
 

  // --------------------------
    
    33-  showDialog  in flutter   : 
        a-   create a button to display   { showdialog ()}  
         

  // --------------------------

    34-  [showBottomSheet] & [SnackBar]   in flutter   : 
        a-  Creating button to show the [showBottomSheet] => include specific informtation                 
        b-  Creating button to show the [SnackBar] => include specific informtation message                           

  // --------------------------


    35 / 36 / 37 / 38   -  [ E-commerce parts;  1 , 2 ,  3 ,   4]  / []   in flutter  : 
        design [2] screens of following  :  
          a-  [lib/homepage.dart] {}  => 
            -- seperated page file being  imported  inside {main.dart}  ->  within  the   materialApp : 'home' property    
            -- {homepage.dart}  => [Homepage] custom widget  
     

          b-  [lib/details.dart] {}  => 
            -- seperated page file being  imported  inside {main.dart}  ->  within  the   materialApp : ' ' property     
            -- {details.dart}  => [Details] custom widget  
     


  // --------------------------


 */

// importing section  :

import 'package:flutter/material.dart';

// importing exteranl files  :
// import 'package:project/customcard.dart';

import 'package:project/homepage.dart';
// import 'package:project/about.dart';
// import 'package:project/contact.dart';

// ----------------------------------------

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

// B- define a main  class method [_MyAppState]  extended from the defined main  [MyApp] [StatefulWidget]   :
class _MyAppState extends State<MyApp>   {
  // a-  Define public variables :

  // 1- define a scaffold key variable to be used in controling the drawer withoput need to use [appbar] :
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();

  // 2- define a [tabController] variable  [with datatype tabController ] to be used as value of custom of {controller} property  [for tabbar ] :
  TabController? tabController;
  //-------------------------------------

  // 3- define a [selected index] variable to be used dynamic switching using the  [for    bottom navigaiotn bar]   :
  int selectedIndex = 0;
  //-------------------------------------

  // 4- define a [widgetList]  variable   of widgets  , to be used as assumed pages contents to  naviagte through it  :
  List<Widget> widgetList = [
    Text(
      "page 1",
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),
    Text(
      "page 2",
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),
    Text(
      "page 3",
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),
  ];
  //------------------------------------

  // 5- define a list to be used pageview builder :
  List imageNames = ['assets/images.png', 'assets/images.png'];

  //------------------------------------

  // Define {initState} function to be executed once the screen is loaded  [according to the {custom controller}  ]  :
 
  // b- using widget building function  :
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // [calling  the imporetd [Homepage] inside 'home' property to be the first page opened by default  ]
      home: Homepage(),

  
    
      // Define a map of the routes - to be used in all project -  :
      // routes : {      
      //   "home" :  (context)  =>   Homepage(), 
      //   "about" :  (context) =>   About(), 
      //   "contact" :  (context)  =>   Contact(), 
      // }, 

   
    );
  }
}
//  ---------------------------------------------------------


 