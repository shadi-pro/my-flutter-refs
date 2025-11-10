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
// #[4: 31]
// -------------------------------------

// importing  public  packages:
import 'dart:convert';

import 'package:flutter/material.dart';

// importing  [http] package   :
// import 'package:http/http.dart';

// => importing custom packages [awesome_dialog]:
// import 'package:awesome_dialog/awesome_dialog.dart';

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

  // define a list of the obtained data to recieve inside it  :
  // List data = [];

  // define a variable of loading status [with  'true'  value by default]  because non need to activarted by a button click   egnet       :
  // bool loading = true ;

  // a- public function [getData] of [Future  + List type - to be matched with {FutureBuilder<List>}   - ] type => to be used in handling the conoection with the assiged api :
  Future<List> getData() async {
    // 0- setting the loading data with true before displaying  data  below :
    // loading = true;
    // setState(() {}); //  not needed here

    // 1- define [response] variable , assigned  with value of obtained raw data from assigned  api url  by using the  [get()] method  :
    var response = await get(
      Uri.parse("https://jsonplaceholder.typicode.com/posts")
    );

    // 2- define [responsebody] variable of [list type]  assigned with  converted obtained data value form [json string] into  list of maps by using the [jsonDecode] method  :
    List bodyresponse = jsonDecode(response.body);

    //  adding the obtained data converted to list  [bodyresponse] inside the defined list as an addition to the list :
    // data.addAll(bodyresponse);

    //  reset the loading variable by false again  :
    // loading = false;

    // using the {setState} to dynamic display above data into the UI  [ for dynamic refresh  displaying ] :
    // setState(() {});   not needed here

    // 3- this method must has a return value  [which will be assigned inside the 'snapshot' property of FutureBulder()   ]    :
    return bodyresponse ;
  }

    
    
  // b- Calling the upper defined  function of {getData} top be operated before loading the  page :
  @override
  void initState() {
    getData();
    super.initState();
  }



   // II] main  build  method  :
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Future Builder '), actions: []),

      // a- use  [{futureBuilder} - as main container of  the body ] with using both it's  properties [future , builder]  by a [list]  type - to not being considered by a object  -   :
      body: FutureBuilder<List>(
        // 1- [assigned by the returned  previous defined connection function with assitgned  api [  of future + list type {getData()}] 
        future: getData(), 
        
        // 2- [ snapshot is holding the returned value of the assgined method inside the 'future' property ]
        builder: (context, snapshot) {
          // a) [connection waiting state]  returning widget :
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          //  b) [if connection state is 'done' (stablished successfully ) ] :
          if (snapshot.connectionState == ConnectionState.done) {
            // 1) returning  error result :
            if (snapshot.hasError) {
              return Text("Error");
            }

            //  2)  return the obtained data if form of [list] as looped inside the api list of  {  snapshot.data }    :
            if (snapshot.hasData) {      // [ can return the main dierectly without  {snapshot.hasData} ] :
              return ListView.builder(
                itemCount: snapshot.data!.length,  // [ 'data'  is the list name the obtained of assigned api ] 
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text("${snapshot.data![i]['title']}"),
                    subtitle: Text("${snapshot.data![i]['body']}"),
                  );
                },
              );
            }
          }

          // c) main return  [non-conditional]  of the builder method property   :
          return Text("");
        },
      ),
    );
  }
}

// ---------------------------
// ---------------------------
