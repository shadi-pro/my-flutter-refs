// [Homepage] {homepage.dart}   =>  Home page to be called  within  {main.dart} witnin [scaffold] : 'home'

//  a custom widget as a [home page]  of  project [E-commerce] , to be imported inside the [main.dart]
//  this  custom widget  of  [home page]  will send data of {data} as defined list for each product duynamic data

//  Screen Contents  => Container of [Listview] including  next  elements :

// 1- [Row]   => search input field   +  shortcut menu icon   :
//  a- [Expaneded] =>  including  [TextFormField]
//  b- [TextFormField] => thre main serach text field with custopm formating

// 2-  [Text] => Title of categories section

//  3-  [Container]  =>  [listview]  of [container]  including [column] =>  (each column contains a category's detaitls  )   :
// Adding  [.builder()]  for making it more dynamic by loooing inside a defind list of objects [categories]
//   a-   [container] -> contains  child of [icon] of category [ category Icon ]     </li>
//   b-   [ text ]   -> [label] of [category title ]       </>

// 4-  [Containers] => inbetween  empty contianers as seperators

// 5- [Text]  =>  Title  of [Best Selling ] section

// 6- [GridView.builder()]  =>   [Best selling products] section  ,  with next properties:
// Adding  [.builder()]  for making it more dynamic by looping inside a defind list of objects [products]
// [physics: NeverScrollableScrollPhysics()] => Cancel gridview scroll property to not be struggle with parent container scroll property
// [shrinkWrap: true]  =>  activate the  {shrinkWrap} ] to prevent nto dispalayed  chlid
// [gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2) ]   =>   assign the count each row of grid
// [ itemBuilder()  ]  => return dynamic  [Card ] widget of [column] of children for each product's detail as looped item inside the defined [products] , following contents  :     <br>
// [ Card ] => [Column] =>  including :
// - [contianer]  :  dynamic  product image
// - [text]  :   dynamic  product title
// - [text]  :   dynamic  product desdcription
// - [text]  :   dynamic  product  price

// 7-   [Bottom Navigation bar] section    =>
// include  [3] chidren of :
// a- Home
// b- User
// c- Shopping Busket

//  8- [appbar ] section    =>
// including mainly :
// a {Search delegate}  methodology with [Icon Button] , including  (4) overriders :
//  (1) : [buildActions]  =>  include [clear Search text (empty query )]
//  (2) : [buildLeading]  =>  include  [close search box] action as [Back button]
//  (3) : [buildResults]  =>  include display the query value within the searching result
//  (4) : [buildSuggestions]  =>  include [Searching suggestions container] according the inserted 'query' , using static reference defined  List

// 9- [Scroll]  =>  use [scroling controller]   to provide advanced scroling for the inner  children  of container ,  as next :
//  a)   navgiating button to top of screen         
//  b)   navgiating button to bottom  of screen         
//  c)   printing the current [offset] value of the current screen => within in [initstate] method [ using the  {scrollController}  defined event        ]



// 10- [ package ]  =>    :
//  a) concept example and methology   
//  b) main source to get and install mobile packages  + methods and steps to install and use it   
//  c) mentality to solve any issues to be thrown while run app related to the installed package , and example to solve it  
 
// -------------------------------------

import 'package:flutter/material.dart';
 
 
// creating  custom [statefulwidget] to be imoprted in another file       :
class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}
// -------
// ------------------------------------

class _HomepageState extends State<Homepage> {
  // A] public definitions  :

  // 1- define empty variable fo {ScrollController} type to be used for the [scroll controler]  :
  ScrollController? scrollController;

  
  
  // 2- define a [initial state] overrider  method for assigning  [Scroll Controller]  by start loading screen :
  @override
  void initState() {
    
    // assign the {scrollController} variable  as extracted  from  ScrollController() :
    scrollController = ScrollController();

    // setting a custom feature for  [scroll controller] =>  ( printing the value of the scroll offset   )     :
    scrollController?.addListener(() {
      // [min offset (screen top) : 0] , [max offset (screen  bottotm) : 9337 ]
      print("${scrollController?.offset}");
    });

    super.initState();
  }



  // 3- define a dispose method for the created controller [disposing created controller for best performance ] :
  @override
  void dispose() {
    
    //  disposing the defined variable of [scrollController] :
    scrollController?.dispose();

    super.dispose();
  }

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scroll'), actions: []),

      body: ListView(
        // 4- assign the defined variable of  [scrollcontroller] inside the controller property  of listing widget   :
        controller: scrollController,

        children: [
          
          // 5- [navigation button] to [screen  bottom] using  [scrollController's offset] value:
          MaterialButton(
            onPressed: () {
              // scrollController?.jumpTo(9433);    // [instant jump]

              // [animated jump]
              scrollController?.animateTo(
                9433,
                duration: Duration(seconds: 1),
                curve: Curves.ease,
              ); 
            },
            child: Text('Jump to Screen Bottom'),
          ),

          // 6- generating list of 100 children to test scrolling in flutter [using method of  {List.generate}]      :
          ...List.generate(
            100,
            (index) => Container(
              alignment: Alignment.center,
              height: 100,
              child: Text("$index", style: TextStyle(fontSize: 25)),
              color:
                  index.isEven
                      ? Colors.red
                      : Colors
                          .green, // [conditional coloring for continer according to index value  ]
            ),
          ),

          // 7- [navigation button] to [Screen Top] using [ scrollController's offset] value  :
          MaterialButton(
            onPressed: () {
              // scrollController?.jumpTo(0);    // [instant jump]

              // [animated jump]
              scrollController?.animateTo(
                0,
                duration: Duration(seconds: 1),
                curve: Curves.ease,
              ); 
            },
            child: Text('Jump to Screen Top'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------
