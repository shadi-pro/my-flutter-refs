/* {listgenerate.dart}  => inner page of each dynamic selected product from {homepage}  inner page  :
  -  some practical apps  on the   usage of  [ list.generate ]           
  - defferences between the   [ list.generate() ] * [listView.builder()  ]  :
    a- [list.generate() ]  =>   looping in a defined list with of scroling      
    b- [listView.builder() ]  =>  looping in a defined list with of + defualt scroling       
 
 
*/

import 'package:flutter/material.dart';

class ListGenerate extends StatefulWidget {
  // this variable [ the sent form the {homepage.dart} ] and will be used to pass through all properties defind and sent from another files :
  // final data;

  const ListGenerate({super.key});

  @override
  State<ListGenerate> createState() => _ListGenerateState();
}

class _ListGenerateState extends State<ListGenerate> {
  // Define a manual list of objects  :
  List usernames = [
    {'name': "Shadi", 'age': 22},
    {'name': "Sayed", 'age': 33},
    {'name': "Ali", 'age': 25},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' E-Commerce', style: TextStyle(color: Colors.black)),

        iconTheme: IconThemeData(color: Colors.grey[800]),
        backgroundColor: Colors.grey[200],
        elevation: 0.0,
      ),

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

      body: ListView(
        children: [
          // Card(child: ListTile(title: Text(usernames[0]["name"]))),
          // Card(child: ListTile(title: Text(usernames[1]["name"]))),
          // Card(child: ListTile(title: Text(usernames[2]["name"]))),

          // whebn using the {List.generate} insise the ListView require using the seperator  operaotor (...) before the  method :
          // 1-  generating list of defined list :
          ...List.generate(usernames.length, (i) {
            return Card(child: ListTile(title: Text(usernames[i]["name"])));
          }),

          // 2- generating list of numbers of generator method's index :
          ...List.generate(100, (i) {
            return Text('$i');
          }),

          // 3- generating list of birth dates by usign both of generator method's index + years values    :
          ...List.generate(126, (i) {
            return Text('${i + 1900}', style: TextStyle(fontSize: 30));
          }),
        ],
      ),
    );
  }
}
