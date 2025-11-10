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

    * [ Example part 1  ] =>  about all previous lessons to implement a UI flutter design using all studied widgets  :
    - This application will include some new properties of widgets      
      
   // This app descrption   :
      - design a main container [Container] , that include one [Column] that contains => children [3 Containers ] as following   : 
        -- [First Container] =>    
           has special  properites  + include [Text]   

        -- [Second Container] =>    
            has special  properites  + include [Text]   

        -- [Third Container] =>    
          has special  properites  + include: 
            --- [ Row ] =>  include  (2) children  : 
              -----  [Row] -> contains (5) icons of stars 
              -----  [Text] -> contains text of reviewer count   
  ----------------------- 

  * [ Example part 2] =>
    - complete  designing the  previous application , as following: 
      --  adding new container child [Container ]  wihtin the direct parent container  [column]  -> that will include one container {Row} , which will : 
        --- (3)  [children]  {Column}
        ---  alinging hte inner childner using one olny  of  the  next  methods : 
            a-  [ MainAxisAligment  ] property  of parent  contern   [Row] 
            b-  [ Spacer()] child  widget in-between the inner  children of main  Container  [Row]        
  -----------------------------

  11-  [ Button]  widgets  => 
    a-    { MaterialButton(  ) } widget type   
    b-    { IconButton(  ) } widget type   
    c-    { floatinhgActionButton(  ) } widget type   
  -----------------------------
 
  12-  [  StatefulWidget ] &  [Statelesswidget ] (current)  => 
    a-    { setState() {} }  interactive method used inside [StatefulWidget] 
    b-    creating  counter app 
    c-    creating clickable favourate rating   star app [2 clicakble buttons ]
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
  
  // 1- define an object from this class wiht using hte [key] parameter with using hte super keyword   :  
  const MyApp({super.key});

    // 2- define a private method of state type  :
  @override
  State<MyApp> createState() => _MyAppState();
}

// B- define a new class from  the defiend private metod [_MyAppState] :
class _MyAppState extends State<MyApp> {
  
  // 1-  define public variables     :
  int i = 0;
  bool status = false;
 
  
  // 2- using widget building function   :
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
        floatingActionButtonLocation:
            FloatingActionButtonLocation
                .endFloat, // [ centerTop , centerFloat ,  endFloat, startFloat , ......    ]

        // [the main container of the  all  page ]
        body:   
          Container(
            padding: EdgeInsets.all(10) , // [this will set main container with inner padding  to set all its children in full width - instead of setting each widget ]

            child: Column(
              children: [
                // [increment  function]  button in the flutter  [IconButton] :
                IconButton(
                  onPressed: () {
                    setState(() {
                      i++;
                    });
                    print(
                      "Increment function activated , current  number = ${i} ",
                    );
                  },
                  icon: Icon(Icons.add),
                ),

                // result text  :
                Text('Counter = ${i}'),

                //  [decrement  button function ] button in the flutter  [IconButton] :
                IconButton(
                  onPressed: () {
                    setState(() {
                      i--;
                    });
                    print(
                      " decrement function activated , current number  = ${i}",
                    );
                  },
                  icon: Icon(Icons.remove),
                ),

                //  [ Reset button function  ] button in the flutter  [IconButton] :
                IconButton(
                  onPressed: () {
                    setState(() {
                      i = 0;
                    });
                    print(
                      "  Re-setting  function activated , current number  = ${i}",
                    );
                  },
                  icon: Icon(Icons.remove),
                ),

                Spacer(),

                //  [ Rate Button ]  favaourite icon stars ratting button in the flutter  [IconButton] :
                // IconButton(
                //   icon: Icon(Icons.link),
                //   onPressed: () {
                //     print("  Ratting  function activated  ");
                //     status = true;
                //   },
                // ),

                //  [ Star favourite icon  ]    using [IconButton]  :
                IconButton(
                  icon: Icon(Icons.link), // [default icon]
                  onPressed: () {
                    setState(() {
                      status = true;
                      print(" Rating star statues changed    ");
                    });

                    // conditional star icon accordgin to the defined variable [status] :    :
                    status
                        ? Icon(Icons.star)
                        : Icon(
                          Icons.star_border_outlined,
                        ); // [ the changing condition ]
                  },
                ),

                //  [ UnRate Button ]  favaourite icon stars ratting button in the flutter  [IconButton] :
                IconButton(
                  icon: Icon(Icons.link_off),
                  onPressed: () {
                    setState(() {
                      status = false;
                      print(" Not Ratting  function activated  ");
                    });
                  },
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
    