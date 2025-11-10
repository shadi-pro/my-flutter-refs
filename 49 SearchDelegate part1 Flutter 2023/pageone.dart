//  main idea in this page widget :
//    -

// -----------------------------------------------------

import 'package:flutter/material.dart';
// import 'package:project/contact.dart';

// creating  custom [statefulwidget] to be imoprted in another file :

class PageOne extends StatefulWidget {
  // add define the property(s) into  constructor function    of [Home] :
  const PageOne({super.key});
  @override
  State<PageOne> createState() => _PageOneState();
}

// ------------------------------------

class _PageOneState extends State<PageOne> {
  // A] public definitions  :

  //  -------------------------------

  
  // define the {initState} function - with using the {super} keyword to inherite all statefullwidget properties -  :
  @override  
  void initState() {
    print('===================== Enter Page One') ;
    super.initState();
  }
  // ---------------------------------------------------


  // define the {dispose} function - with using the {super} keyword to inherite all statefullwidget properties -  :
  @override  
  void dispose() {
    print('===================== Dispose Page One') ;
    super.dispose();
  }
  // --------------------------------




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' [PageOne] Inner page  Initial State  & Dispose '),
      ),

      body: ListView(
        children: [
          MaterialButton(
            onPressed: () {
              //  when navigating to [home page] will remove any exsited page in qeue :
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil("home", (route) => false);
            },
            child: Text('go to Home '),
          ),

          MaterialButton(
            onPressed: () {
              Navigator.of(context).pushNamed("pagetwo");
            },
            child: Text('go to Page two '),
          ),
        ],
      ),
    );
  }
}
