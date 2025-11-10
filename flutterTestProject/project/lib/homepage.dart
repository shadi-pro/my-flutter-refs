// [Homepage] {homepage.dart}   =>  Home page to be called  within  {main.dart} witnin [scaffold] : 'home'

//  a custom widget as a [home page]  of  project [E-commerce] , to be imported inside the [main.dart]
//  this  custom widget  of  [home page]  will send data of {data} as defined list for each product duynamic data

//  Screen Contents  => Container of [Listview] including  next  elements :

// 1- [Row]   => search input field   +  shortcut menu icon   :
//  a- [Expaneded] =>  including  [TextFormField]
//  b- [TextFormField] => thre main serach text field with custopm formating
// ----------------------------------------------------

// 2-  [Text] => Title of categories section :
// ----------------------------------------------------

//  3-  [Container]  =>  [listview]  of [container]  including [column] =>  (each column contains a category's detaitls  )   :
// Adding  [.builder()]  for making it more dynamic by loooing inside a defind list of objects [categories]
//   a-   [container] -> contains  child of [icon] of category [ category Icon ]     </li>
//   b-   [ text ]   -> [label] of [category title ]       </>
// ----------------------------------------------------

// 4-  [Containers] => inbetween  empty contianers as seperators :
// ----------------------------------------------------

// 5- [Text]  =>  Title  of [Best Selling ] section
// ----------------------------------------------------

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
//------------------------------------------------------

// 7-   [Bottom Navigation bar] section    =>   include  [3] chidren of :
// a- Home
// b- User
// c- Shopping Busket
// ------------------------------------------------------

//  8- [appbar ] section    =>    including mainly :
// a {Search delegate}  methodology with [Icon Button] , including  (4) overriders :
//  (1) : [buildActions]  =>  include [clear Search text (empty query )]
//  (2) : [buildLeading]  =>  include  [close search box] action as [Back button]
//  (3) : [buildResults]  =>  include display the query value within the searching result
//  (4) : [buildSuggestions]  =>  include [Searching suggestions container] according the inserted 'query' , using static reference defined  List
// -----------------------------------------------------------

// 9- [Scroll]  =>  use [scroling controller]   to provide advanced scroling for the inner  children  of container ,  as next :
//  a)   navgiating button to top of screen
//  b)   navgiating button to bottom  of screen
//  c)   printing the current [offset] value of the current screen => within in [initstate] method [ using the  {scrollController}  defined event        ]
// ---------------------------------------------------------

// 10-  {awesome_dialog} package    =>    :
//  a) concept example and methology
//  b) main source to get and install mobile packages  + methods and steps to install and use it
//  c) mentality to solve any issues to be thrown while run app related to the installed package , and example to solve it
//  d) using the installed  package of [ awesome_dialog]  [need to be intalled ]   =>    as an button onPressed event
//  --------------------------------------------------------

// 11-  {http} package [part1 , part2]  =>    :
//  a) this pacakage will be used to test requesting data from a given trail api url
//  b) this package include using the [get()] method with {jsonDecode()}  mehtod to decode the obtainded raw data into a json list of maps
//  c)  getting data from the assinged api  requring the next steps:
//  1) Define the next variables :
//  -- list {data} : define a list of the obtained data to recieve inside it
//  -- bool  {loading} : define a variable of loading status [with false value by default]

//  2) Using the {get} method of [http package]  inside the (onPressed) of button to get data form the assigned url +  using the [async-await]  :
//  -- setting the loading data with true before displaying  data  below
//  -- define [response] variable , assigned  with value of obtained data from assigned  api url  by using the  [get()]
//  -- define  [responsebody]  variable assigned with  converted obtained data value form [json string] into  list of maps by using the [jsonDecode] method
//  -- adding the obtained data converted to list  [bodyresponse] inside the defined list as an additoin to the list
//  -- reset the loading variable by false again
//  -- using the {setState} to dynamic display above data into the UI  [ for dynamic refresh  displaying ]

//  3) Conditional displaying of loading indicator {CircularProgressIndicator}  - incase of  the loading is true -

//  4) Generate a list and add the obtained data inside desired widget as looped list elements

// 5)  [dropdown] list usign   the [ drop down list ] package   :  # [ 12 : 31 ]
//  with in the [apptextfield] file
// -------------------------------------

// A] importing  public  packages:

// 1- importing [flutter/material]  :
import 'package:flutter/material.dart';

// 2- importing  [dropdown list ] package :
// import 'package:drop_down_list/drop_down_list.dart';

// 3- importing  [dropdown list ] model  :
// import 'drop_down_list/model/selected_list_item.dart';

// 4- importing  [ apptextfield  ] file   :
import 'package/apptextfield.dart';

// ------------------------------------

// creating  custom [statefulwidget] to be imoprted in another file       :
class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}
// -------
// ------------------------------------

class _HomepageState extends State<Homepage> {
  //  I] public definitions  :
    // 1- define a variable list of [country] as first list in of searching :
    TextEditingController country = TextEditingController();
    
    // 2- define a variable list of [age] as second list  of searching :
    TextEditingController age = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drop Down search List  widget package '),
        actions: [],
      ),

      body: ListView(
        children: [
          
          // 1-  [calling the first defined list usig the {AppTextField} widget  pacakage ]  :
          AppTextField(
            // assign values of defined attribute list [datalist]  {there can be multiple defined lists }  :   
            datalist: [
              SelectedListItem(name  :'Egypt' ) ,     // [{SelectedListItem} representing single item    ]
              SelectedListItem(name  :'Syria' ) ,    
              SelectedListItem(name  :'Qatar' ) ,    
              SelectedListItem(name  :'Iraq' ) ,    
              SelectedListItem(name  :'Oman' ) ,    
              SelectedListItem(name  :'Kuwait' ) ,    
             ],
            textEditingController: country,
            title: 'Select Country ',
            hint: 'Country ',  
            isCitySelected: true,
          ),


          // 2- [calling the second  defined list usig the {AppTextField} widget package ]  :
          AppTextField(
            // assign values of defined attribute list [datalist]  {there can be multiple defined lists }  :   
            datalist: [
              SelectedListItem(name  :'18' ) ,     // [{SelectedListItem} representing single item    ]
              SelectedListItem(name  :'20' ) ,    
              SelectedListItem(name  :'30' ) ,    
              SelectedListItem(name  :'31' ) ,    
              SelectedListItem(name  :'19' ) ,    
              SelectedListItem(name  :'35' ) ,    
             ],
            textEditingController: age,
            title: 'Select Age ',
            hint: 'Age ',  
            isCitySelected: true,
          ),



        ],
      ),
    );
  }
}

// ---------------------------
// ---------------------------
