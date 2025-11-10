


//  {details.dart}  [ItemDetails] inner page  =>  to be called insde the {main.dart} within   [scaffold] : 'home'

//  a custom widget as a [item details page]  of project [E-commerce] , to be imported inside the [main.dart]
//  [Props] => this  custom widget [item details]  page  will recieve data [dataitem ] from the [ Homepage] for each product

//  [Screen Contents]  => including next elements :
  // I]  setting sector   : 
    // a- [Appbar] -> including :
    //  {Row}   : of 3 children  [2 text   + icon ]

    // b- [BottomNavigationBar] section -> including  :
    //  (3) { children } of [BottomNavigationBarItem] =>  as icons


  // II]  body  sector   : 
    // main contianer of   mainly [ListView] , including  :      
        // 1-  [product image] section ->  direct image          
        // 2-  [product title] section ->  custom [container] -> including [Text] 
        // 3-  [product  description] section  ->  custom [container] -> including [Text]       
        // 4-  [product  price] section  ->  custom [container] -> including [Text]
        // 5-  [product (2) color details options displayer ] section  ->   [Row] lncluding [Text] and  custom [container]    

        // 6-  [product sizes detials options ] =>  single [text] ,  the next values will be recieved as list from api backend  [in practical real app]  
        // 7-  [Add to cart] button =>  cutom container  ->  including [material button] {without a fumction of hte {onPassed}   }
     
// -------------------------------------

import 'package:flutter/material.dart';
// import 'package:project/contact.dart';

// creating  custom [statefulwidget] to be imoprted in another file :

class ItemDetails extends StatefulWidget {
  // define the property(s) to be recieved from [home page] as final  :
  final dataitem;

  // add define the property(s) into  constructor function    of [ItemDetails] :
  const ItemDetails({super.key, this.dataitem});
  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}
// -------
// ------------------------------------

class _ItemDetailsState extends State<ItemDetails> {
  // A] public definitions  :

  //  -------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1- setting the [app bar] properites   :
      appBar: AppBar(
        //  building the halved text using   [row] of (2) text  :
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(Icons.shop_outlined, color: Colors.black),
            Text(' Shadi ', style: TextStyle(color: Colors.black)),
            Text(' E-commerce', style: TextStyle(color: Colors.orange)),
          ],
        ),

        //  controling the appbar icon color :
        iconTheme: const IconThemeData(color: Colors.grey),

        backgroundColor: Colors.grey[200],
        elevation: 0.0, // [ remove the elevation effect]
      ),

      // 2- setting the [Drawer] :
      endDrawer: const Drawer(),

      // BottomNavigationBar section  [ the same of Homepage] :
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,

        selectedItemColor: Colors.orange,

        //   main icons inside bottom navigation bar     :
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

      body: Container(
        padding: EdgeInsets.all(20),

        child: ListView(
          // [using one of recieved data variable from [Homepepge] + using the {widget} due to using indirect class  ]
          children: [
            // 1- product image    :
            Image.asset(widget.dataitem['image']),

            // 2- product title   :
            Container(
              child: Text(
                widget.dataitem['title'],
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),

            // 3- product description    :
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                widget.dataitem['desc'],
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[800], fontSize: 20),
              ),
            ),

            // 4- product price    :
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 25),
              child: Text(
                widget.dataitem['price'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 5- product details options displayer [color] :
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text('Color :', style: TextStyle(color: Colors.green)),

                SizedBox(width: 10),

                //  color option  icon 1  :
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey,
                    border: Border.all(color: Colors.orange),
                  ),
                ),

                Text("Grey"),

                SizedBox(width: 20),

                //  color  option  icon 2  :
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    // border: Border.all(color: Colors.orange),
                  ),
                ),

                Text("Black"),
              ],
            ),

            // 6- [product sizes ] => the next values will be recieved as list from api backend  [in practical real app] :
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                "size : 34 35 40 42 ",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),

            // 7- [Add to cart] button     [just only design without function ] :
            Container(
              margin: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
              child: MaterialButton(
                onPressed: () {},
                color: Colors.black,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
