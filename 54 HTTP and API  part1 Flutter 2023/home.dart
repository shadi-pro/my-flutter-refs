 //  main idea in this page widget :
//  using the new method  of  {Listgenerator} in generating dynamic list  elements in a looping insdie a defined list returing  [card] - without [scroll bar]  -

// -----------------------------------------------------

import 'package:flutter/material.dart';
// import 'package:project/contact.dart';

// creating  custom [statefulwidget] to be imoprted in another file :

class Home extends StatefulWidget {
  // add define the property(s) into  constructor function    of [Home] :
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

// ------------------------------------

class _HomeState extends State<Home> {


  // A] public definitions  :
   //  -------------------------------

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(' Initial State  & Dispose ')),

      body: ListView(
         children: [ 
              MaterialButton(
            onPressed: () {
              Navigator.of(context).pushNamed("pageone");
            },
            child: Text('go to  Page One '),
          ),
          
          MaterialButton(onPressed: () {
              Navigator.of(context).pushNamed("pagetwo");
          }, child: Text('go to Page two ')),


         ],  

      )  
    );
  }
}
