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

//  8- [appbar ] sectoin    =>
// including several   {PopupMenuButton}   => inside  action property

// -------------------------------------

import 'package:flutter/material.dart';
import 'package:project/details.dart';
// import 'package:project/contact.dart';

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

  // 1- Define [Categories list] :
  List categories = [
    {"iconname": Icons.laptop, "title": "Laptop"},
    {"iconname": Icons.phone_android_outlined, "title": "Phone"},
    {"iconname": Icons.electric_bike, "title": "Bike"},
    {"iconname": Icons.card_giftcard_outlined, "title": "Gift"},
    {"iconname": Icons.electric_car_outlined, "title": "Car"},
    {"iconname": Icons.laptop, "title": "Laptop"},
  ];

  //  -------------------------------

  // 2- Define [Products] list :
  List products = [
    {
      "image": "assets/images/download.png",
      "title": "Wireless Headphone",
      "desc": "Wireless Headphone description",
      "price": "200\$",
    },
    {
      "image": "assets/images/download.png",
      "title": "Watch",
      "desc": "Smart Watch description",
      "price": "150\$",
    },
    {
      "image": "assets/images/download.png",
      "title": "Cap",
      "desc": "Smart Men Cap description",
      "price": "10\$",
    },
    {
      "image": "assets/images/download.png",
      "title": "T-shirt",
      "desc": "Smart Men T-shirt description",
      "price": "100\$",
    },
  ];

  //  -------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  [Appbar] -> including  [PopupMenuBottom] :
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            // 1- a function to be implemented  by selecting any item [PopupMenuItem] of [PopupMenuButton] list , using hte (val)  parameter of (val)  as the returned value of elcted item :
            onSelected: (val) {
              if (val == 'valueOne') {
                print('$val has selected as first item');
              } else if (val == 'valueTwo') {
                print('$val has selected as second  item ');
              }
            },


            // 2- executed by open the menu of  [PopupMenuButton ]     :
            onOpened: () {
              print("menu opened ");
            },
            
            // 4-  executed by close  the menu of  [PopupMenuButton ]     :
            onCanceled: () {
              print("menu closed ");
            },

            // 5-  color of the (menu icon)  & (inner items )    :
            color: Colors.green  ,

    
            // 6- controling the [PopupMenuButton] icon :
            icon : Icon  (Icons.access_alarm , color: Colors.white )    , 


            //  7- builder method of the list 's items :
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    child: Text("one"),
                    value: "valueOne" ,
                    onTap:() {print('one taped ') ;} ,
                    textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold , color: Colors.red  ),  
                    // mouseCursor: MouseCursor.defer ,
                    // padding :  , 
                    // height : , 
                  ),
                  
                  PopupMenuItem(
                    child: Text("two"), 
                    value: "valueTwo" , 
                     onTap: () {print('two taped '); }
                  ),
                ],
          ),
        ],
      ),

      // BottomNavigationBar section  :
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,

        selectedItemColor: Colors.orange,

        //   main icons inside bottom navigation bar  :
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '*'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: '*',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: '*',
          ),
        ],
      ),

      // appBar: AppBar(title: const Text('Home Page of E-commerce project ')),
      body: Container(
        padding: EdgeInsets.all(20),

        child: ListView(
          children: [
            // 1- [ screen search bar  +  shortcut menu icon ] :
            Row(
              children: [
                // [Expanded textformfield] :
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      border: InputBorder.none,
                      fillColor: Colors.grey[200],
                      filled: true, // [active color show ]
                    ),
                  ),
                ),

                // [ burger menu icon]
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.menu, size: 40),
                ),
              ],
            ),

            Container(
              height: 30,
            ), // [ (Seperator) represent an empty space between up and]
            // 2- Title of categories section  :
            Text(
              "Categories",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Container(
              height: 30,
            ), // [(Seperator) represent an empty space between up and]
            // 3- container include [listview] of [Categories]   including   (each column of both :  [container : category icon , text : category  title ]  )   :
            Container(
              height: 100,
              child: ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,

                //  Looping inside the defined list of [categories] :
                itemBuilder: (context, i) {
                  return Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        Container(
                          // margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.grey[200],
                          ),
                          child: Icon(categories[i]['iconname'], size: 40),
                        ),
                        Text(
                          categories[i]['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 4 -  Text Title  of [Best Selling ] section  :
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Best Selling",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // 5-  [Best selling products] section  [GridView of returned {card}  for each product's details ]  :
            GridView.builder(
              itemCount: products.length,

              // [Cancel gridview scroll property to not be struggle with parent container scroll property ] :
              physics: NeverScrollableScrollPhysics(),

              // [activate the  {shrinkWrap} ] to prevent nto dispalayed  chlid  :
              shrinkWrap: true,

              //  [assign the count   for each row in  grid] :
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 250,
              ),

              //  looping inside the defined list of the products :
              itemBuilder: (context, i) {
                return InkWell(
                  // setting the navigation process into  {ItemDetails} + adding the details of product as defined list [products]  inside passed variable  {dataitem}  :
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => ItemDetails(
                              dataitem: products[i],
                            ), // [ navigating to the [ItemDetails] with sending data {dataitem} assigned by list varialbe {products} ]
                      ),
                    );
                  },

                  child: Card(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          width: 300,
                          color: Colors.grey[200],
                          child: Image.asset(
                            products[i]['image'],
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                        ),

                        Text(
                          products[i]['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Container(height: 2),

                        Text(
                          products[i]['desc'],
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Container(height: 6),

                        Text(
                          products[i]['price'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
