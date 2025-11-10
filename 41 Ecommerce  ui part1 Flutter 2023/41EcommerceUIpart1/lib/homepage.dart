/*  [homepage] =>
  this page wil include following tips:
   1-  Appbar =>  will be [custom Row]        
   2-  
    

*/

import 'package:flutter/material.dart';
// import '../widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // spacing: double,
              children: [
                Expanded(
                  // putting the TextFormField inside the expanded container to be able to expanced
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search ",
                      border:
                          //  [removing the deafult  border ]
                          InputBorder.none,
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.menu, size: 40),
                ),
              ],
            ),
            Container(height: 30),
            Text(
              "Categories",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Container(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(Icons.laptop, size: 50),
                      padding: EdgeInsets.all(15),
                    ),
                    Text(
                      'laptop',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(Icons.phone_android_rounded, size: 50),
                      padding: EdgeInsets.all(15),
                    ),
                    Text(
                      'Mobile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(Icons.electrical_services, size: 50),
                      padding: EdgeInsets.all(15),
                    ),
                    Text(
                      'Eelectric',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(Icons.card_giftcard_outlined, size: 50),
                      padding: EdgeInsets.all(15),
                    ),
                    Text(
                      'Gifts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
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
