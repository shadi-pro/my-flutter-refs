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
    
    33-  showDialog  in flutter  [current lesson ]     : 
        a-   create a button to display   { showdialog ()}  
         

  // --------------------------


 */

// importing section  :

import 'package:flutter/material.dart';

// importing exteranl files  :
// import 'package:project/customcard.dart';

import 'package:project/homepage.dart';
import 'package:project/about.dart';
import 'package:project/contact.dart';

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
class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
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
  @override
  void initState() {
    // assign the upper defined  variable {tabController}  :
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  // b- using widget building function  :
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // [calling  the imporetd [Homepage] inside 'home' property to be the first page opened by default  ]
      home: Homepage(),
    
      // Define a map of the routes - to be used in all project -  :
      routes : {      
        "home" :  (context)  =>   Homepage(), 
        "about" :  (context) =>   About(), 
        "contact" :  (context)  =>   Contact(), 
      }, 


      //  Scaffold(
      //   key: scaffoldkey,

      //   // 1- [ bottom navigation bar ] of the Home screen :
      //   bottomNavigationBar: BottomNavigationBar(
      //     backgroundColor:
      //         Colors
      //             .lightBlue, // [backgroud color of the all bottom naviagation bar ]

      //     selectedItemColor: Colors.red, // [icon color when selected ]
      //     selectedFontSize: 20, // [icon font size when selected ]

      //     unselectedItemColor: Colors.white, // [icon color when not selected ]
      //     unselectedFontSize: 15, // [icon font size when not selected ]

      //     selectedLabelStyle: TextStyle(
      //       fontWeight: FontWeight.bold,
      //     ), // [label style when selected  ]
      //     // [assign the starting active item using predefined variable ]  => must be assgined manually
      //     currentIndex: selectedIndex,

      //     // [children inside  bottom naviagation bar  ]
      //     items: [
      //       BottomNavigationBarItem(icon: Icon(Icons.person), label: "User"),
      //       BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.settings),
      //         label: "Settings",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.contact_page),
      //         label: "Contact",
      //       ),
      //     ],

      //     // [ (val) parameter -> represent the index of {BottomNavigationBarItem} clicked from {BottomNavigationBar}      ] :
      //     onTap: (val) {
      //       print(val); // display  the (val) value in the console

      //       // [ change the value of the defined variable by the (val) value   => when taping  on an item {BottomNavigationBarItem }   ] :
      //       setState(() {
      //         selectedIndex = val;
      //       });
      //     },
      //   ),

      //   // 2- [app bar] of the Home screen :
      //   appBar: AppBar(
      //     title: Text("  PageView & PageViewbuilder widget  "),
      //     backgroundColor:
      //         Colors.lightBlue, // [ general  background  color of tabbar ]

      //     bottom: TabBar(
      //       controller:
      //           tabController, // [ the custom controller of the upper defined   {} ]
      //       indicatorColor:
      //           Colors.white, // [underline indicator's color of tabbar ]
      //       indicatorWeight:
      //           10, // [underline indicator's  weight of active tab of tabbar ]

      //       labelColor:
      //           Colors
      //               .green, // [Activated Tab content's color inside  tabbar -whether contnet is text or icon] - this properyt will be asignedfor both [labelColor] & [unselectedLabelColor] incases of non existed [unselectedLabelColor]
      //       unselectedLabelColor:
      //           Colors
      //               .grey, // [unActivated Tab content's color inside  tabbar -whether contnet is text or  icon ]

      //       labelStyle: TextStyle(
      //         fontSize: 20,
      //         fontWeight: FontWeight.bold,
      //       ), // [active Tab content's  text style peropties  inside  tabbar ]
      //       unselectedLabelStyle: TextStyle(
      //         fontSize: 20,
      //         fontWeight: FontWeight.normal,
      //       ), // [active Tab content's  text style peropties  inside  tabbar ]

      //       tabs: [
      //         // using only text :
      //         Tab(child: Text("PC")),

      //         // using  [text] + [icon] :
      //         Tab(
      //           iconMargin: EdgeInsets.all(
      //             5,
      //           ), // [the margin between icon and text inside a single tab  ]
      //           icon: Icon(Icons.laptop),
      //           text: "Laptop ",
      //         ),

      //         // using [text] + [icon] :
      //         Tab(icon: Icon(Icons.mobile_friendly), text: "moblie "),
      //       ],
      //     ),
      //   ),

      //   // 3-  [ Starting default Drawer type] (at left side) :
      //   drawer: Drawer(
      //     elevation: 5,
      //     // shape:  ,
      //     backgroundColor: Colors.green,
      //     width: 300,

      //     child: Container(
      //       padding: EdgeInsets.all(15),

      //       // inner content inside of the [drawer]  :
      //       child: ListView(
      //         children: [
      //           //  first main child [ personal profile  icon + title   ]   :
      //           Row(
      //             children: [
      //               // first child for [personal image]   :
      //               Container(
      //                 width: 60,
      //                 height: 60,
      //                 //  {clipRRect}  to assign custom [border radius] + circular image :
      //                 child: ClipRRect(
      //                   borderRadius: BorderRadius.circular(60),
      //                   child: Image.asset(
      //                     "assets/images/shadi.jpg",
      //                     fit: BoxFit.cover,
      //                   ),
      //                 ),
      //               ),

      //               // second child for [expanded textual title] :
      //               Expanded(
      //                 child: ListTile(
      //                   title: Text('Shadi'),
      //                   subtitle: Text('shadidev@gmail.com'),
      //                 ),
      //               ),
      //             ],
      //           ),

      //           //  second main child [inner link 1]   :
      //           ListTile(
      //             title: Text('Home Page '),
      //             leading: Icon(Icons.home),
      //             onTap: () {},
      //           ),

      //           //   third  main child [inner link 2]   :
      //           ListTile(
      //             title: Text('Account Page '),
      //             leading: Icon(Icons.account_balance_rounded),
      //             onTap: () {},
      //           ),

      //           //  fourth main child [inner link 3]   :
      //           ListTile(
      //             title: Text('Order Page '),
      //             leading: Icon(Icons.check_box),
      //             onTap: () {},
      //           ),

      //           //  fifth  main child [inner link 4]   :
      //           ListTile(
      //             title: Text('About us Page '),
      //             leading: Icon(Icons.help),
      //             onTap: () {},
      //           ),

      //           // sixth  main child [inner link 5]   :
      //           ListTile(
      //             title: Text('Contact Page '),
      //             leading: Icon(Icons.phone_android_outlined),
      //             onTap: () {},
      //           ),

      //           // seventh  main child [inner link 6]   :
      //           ListTile(
      //             title: Text('Signout Page '),
      //             leading: Icon(Icons.exit_to_app),
      //             onTap: () {},
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),

      //   // 4- [Ending Drawer default type] (at right side) :
      //   endDrawer: Drawer(),

      //   // 4- add floating action button of the main screen :
      //   floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       print('Hello this is the drawer widget  ');
      //     },
      //     child: Icon(Icons.add),
      //   ),

      //   // 5- assign Location of [floatingActionButton] using the [floatingActionButtonLocation] property :
      //   floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      //   // [the main container of the all page ]
      //   body: Container(

      //     // [this will set main container with inner padding  to set all its children in full width - instead of setting each widget ]
      //     padding: EdgeInsets.all(10),

      //     // dynamic display of item of [list of widgets] according to the assigned selected index parameter   => by assign the defined  list variable {widgetList}  inside child of container , according to it's index by  passing the index as pre-defined variable {selectedIndex} :
      //     child: Column(
      //       children: [

      //         //  Creating [elements] using the created  [custom  stateless widget] 's constructor function     :
      //         CustomListtile(name: "Sayed"  , email: "sayed@gamil.com",  date: "25-6-2025" , imagename: "assets/images/download.png" ) ,
      //         CustomListtile(name: "Ali"  , email: "ali@gamil.com",  date: "25-2-2025" , imagename: "assets/images/download.png" ) ,
      //         CustomListtile(name: "Mohamed"  , email: "mohamed@gamil.com",  date: "25-8-2025" , imagename: "assets/images/download.png" ) ,

      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
//  ---------------------------------------------------------


  
  // 3- building  custom widget  :
  // @override
  // Widget build(BuildContext context) {
  //   return Card(
  //     child: ListTile(
  //       title: Text("$name"),
  //       subtitle: Text("$email"),
  //       trailing: Text("$date"),
  //     ),
  //   );
  // }
