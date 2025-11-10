// [Homepage] =>
//  a custom widget as a [home page]  of  project [E-commerce] , to be imported inside the [main.dart]
//  Screen Contents  => Container of [Listview] including  next  elements :

  // 1- [Row]   => search input field   +  shortcut menu icon   :
    //  a- [Expaneded] =>  including  [TextFormField]    
    //  b- [TextFormField] => thre main serach text field with custopm formating     

  // 2-  [Text] => Title of categories section      

  // 3-  [Row]  => Row of [Categories]  icons  (each column  is a category ) , each  category is about a  [Column]  including    :   
    // a-   [container] -> contains  child of [icon] of category   
    // b-   [ text ]   -> [label] of category     

 
  // 4-  [2 Containers] => empty contianers as seperators      



// -------------------------------------

import 'package:flutter/material.dart';
// import 'package:project/about.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // appBar: AppBar(title: const Text('Home Page of E-commerce project ')),
      
      body: Container(
        padding: EdgeInsets.all(20),
        
        child: ListView(
          children: [

            // [ screen search bar  +  shortcut menu icon ] :    
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

            Container(height: 30), // [ (Seperator) represent an empty space between up and]

            // Title of categories section  :
            Text(
              "Categories",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Container(height: 30), // [(Seperator) represent an empty space between up and]

            // Row of [Catogories]  icons  (each column  is a category   )   :
            Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
               
              
              // 1- [Laptop] :
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.grey[200],
                      ),
                      child: Icon(Icons.laptop, size: 40),
                    ),
                    Text('Laptop' , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.grey[800]  ) ) ,  
                  ],
                ),
              
              
              // 2- [Mobile] :
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.grey[200],
                      ),
                      child: Icon(Icons.phone_android_rounded , size: 40),
                    ),
                    Text('Mobile' , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.grey[800]  ) ) ,  
                  ],
                ),
              
              
                
              // 3- [MotorBikes] :
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.grey[200],
                      ),
                      child: Icon(Icons.electric_bike , size: 40),
                    ),
                    Text('Motor Bikes' , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.grey[800]  ) ) ,  
                  ],
                ),
              
              
                //  [Gifts] :  
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.grey[200],
                      ),
                      child: Icon(Icons.card_giftcard_outlined  , size: 40),
                    ),
                    Text('Gifts' , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.grey[800]  ) ) ,  
                  ],
                ),
               
              
              ],
            ),

          ],
        ),
      ),
    );
  }
}


  // scffold key to be used in both   [showbottombar ] *  [snackbar]
  // GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  //  construction function  :
  // const Homepage({super.key});
 