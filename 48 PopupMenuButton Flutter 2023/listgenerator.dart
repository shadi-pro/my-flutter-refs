//  main idea in this page widget :
//  using the new method  of  {Listgenerator} in generating dynamic list  elements in a looping insdie a defined list returing  [card] - without [scroll bar]  -

// -----------------------------------------------------

import 'package:flutter/material.dart';
// import 'package:project/contact.dart';

// creating  custom [statefulwidget] to be imoprted in another file :

class Listgenerator extends StatefulWidget {
  // add define the property(s) into  constructor function    of [ItemDetails] :
  const Listgenerator({super.key});
  @override
  State<Listgenerator> createState() => _ListgeneratorState();
}

// ------------------------------------

class _ListgeneratorState extends State<Listgenerator> {
  // A] public definitions  :
  List listname = [
    {"name": "Shadi", "age": "30"},
    {"name": "Ali", "age": "25"},
    {"name": "Ahmed", "age": "40"},
  ];
  //  -------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List generator')),

      body: ListView(
        children: [
          
          // [app 1 : generating widgets ] => using the  {List.generate() } to loop inside  the defind [listname]   :
          Text("app 1 : generating widgets ] => using the  {List.generate() } to loop inside  the defind [listname]  var " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20      ) , )  , 
          
          ...List.generate(listname.length, (i) {
            return Card(
              child: ListTile(
                title: Text(listname[i]['name'])
              )
            );
          }),

          
          Container(height:  50,)  ,  
          //  -----------------------------------------------


          // [ app 2 :  creating list of years values from  [1900] untill to [2025]    :
          Text("app 2 :  creating list of years values from  [1900] untill to [2025]  " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20      ) , )  ,

          ...List.generate(
            126,  // [looping counter ]
            (i) => Text("${1900 + i}", style: TextStyle(fontSize: 30)),
          ),

     
        ],
      ),
    );
  }
}
