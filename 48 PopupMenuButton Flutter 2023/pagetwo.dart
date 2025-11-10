 //  main idea in this page widget :
//    -

// -----------------------------------------------------

import 'package:flutter/material.dart';
// import 'package:project/contact.dart';

// Creating custom [statefulwidget] to be imoprted in another file :
class PageTwo extends StatefulWidget {
  // add define the property(s) into  constructor function    of [Home] :
  const PageTwo({super.key});
  @override
  State<PageTwo> createState() => _PageTwoState();
}

// ------------------------------------

class _PageTwoState extends State<PageTwo> {


  // A] public definitions  :
   //  -------------------------------



  //  define the {initistate} function wiht using the {super} keyword to inherite all statefullwidget properties    :
  @override  
  void initState() {
    print('===================== Enter Page Two') ;
    super.initState();
  }
  // ----------------------------------------

  // define the {dispose} function - with using the {super} keyword to inherite all statefullwidget properties -  :
  @override  
  void dispose() {
    print('===================== Dispose Page Two') ;
    super.initState();
  }

   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(' [PageTwo] Inner page  Initial State  & Dispose ')),

      body: ListView(
         children: [ 
          MaterialButton(
            onPressed: () {
               //  when navigating to [home page] will remove any exsited page in qeue :
              Navigator.of(context).pushNamedAndRemoveUntil("home" , (route) => false   ); 
            },
            child: Text('go to Home '),
          ),
          
          MaterialButton(onPressed: () {
              Navigator.of(context).pushNamed("pageone");
          }, child: Text('go to Page One')),


         ],  

      )  
    );
  }
}
