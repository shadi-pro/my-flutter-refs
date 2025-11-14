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
        children: [
          // accessing the defined list [items]  using 'data' property in case of using 'stafulwidget' (NOT incase of 'stateless' widget) => we must use the 'widget' to reach all sent properties from the parent :
          Image.asset(widget.data['image']),
        ],
      ),
    );
  }
}
