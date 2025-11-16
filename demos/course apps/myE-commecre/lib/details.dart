//  {details.dart}  => inner page of each dynamic selected product from {homepage}  inner page     :

import 'package:flutter/material.dart';

class ItemsDetails extends StatefulWidget {
  // this variable [ the sent form the {homepage.dart} ] and will be used to pass through all properties defind and sent from another files :
  final data;

  const ItemsDetails({super.key, this.data});

  @override
  State<ItemsDetails> createState() => _ItemsDetailsState();
}

class _ItemsDetailsState extends State<ItemsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        selectedItemColor: Colors.orange,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "home",
          ),
        ],
      ),
      endDrawer: Drawer(),
      appBar: AppBar(
        // centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shop_2_outlined, color: Colors.black),
            Text(' Shadi ', style: TextStyle(color: Colors.orange)),
            Text(' E-Commerce', style: TextStyle(color: Colors.black)),
          ],
        ),

        iconTheme: IconThemeData(color: Colors.grey[800]),
        backgroundColor: Colors.grey[200],
        elevation: 0.0,
      ),

      body: ListView(
        // accessing the defined list [items]  using 'data' property in case of using 'stafulwidget' (NOT incase of 'stateless' widget) => we must use the 'widget' to reach all sent properties from the parent :
        children: [
          Image.asset(widget.data['image']),
          Container(
            child: Text(
              widget.data['title'],
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              widget.data['subtitle'],
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 25),
            child: Text(
              widget.data['price'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Color: '),

              SizedBox(width: 20),
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.orange),
                ),
              ),
              // SizedBox(width: 5),
              Text('  Grey'),

              // Text('Color'),
              SizedBox(width: 20),
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.orange),
                ),
              ),
              // SizedBox(width: 5),
              Text('  Blue'),
            ],
          ),

          //  in the real app , this will be recived form hte api as a list  :
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              "Size :   34   35   40  41 ",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            child: MaterialButton(
              padding: EdgeInsets.symmetric(vertical: 15),
              onPressed: () {},
              child: Text('add to Cart'),
              color: Colors.black,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
