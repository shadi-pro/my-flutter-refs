// [homepage] => 
//  a custom widget as a page  to be imported from antother files
// provided with 2 buttons of navigator to:
    //  1- [About page widget] =>  (using the {.pushReplacement} type)] 
    //  2- [Contact page widget] =>  (using the {.push} type)]

import 'package:flutter/material.dart';
import 'package:project/about.dart';
import 'package:project/contact.dart';

// creating  custom [statelesswidget] to be imoprted in another file       :
class Homepage extends StatelessWidget {
  //  construction function  :
  const Homepage({super.key});

  @override
  Widget build(BuildContext contex) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      
      body: ListView(
        children: [
          const Center(
            child: Text('Home Page', style: TextStyle(fontSize: 30)),
          ),

          // 1- Navigate to [About page] -> by using  [ .pushReplacement() ] ] method type [NO back arrow button will be dispalyed after navigation process ] :
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Go to About page '),
              onPressed: () {
                Navigator.of(
                  contex,
                ).pushReplacement(MaterialPageRoute(builder: (contex) => About()) );
              },
            ),
          ),
        
        // 2- Navigate to [Contact page]  -> by using  [ .push() ] method type [ the default back arrow button will be dispalyed after each navigation process using this method   ]   :
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Go to Contact page '),
              onPressed: () {
                Navigator.of(
                  contex,
                ).push(MaterialPageRoute(builder: (contex) => Contact()));
              },
            ),
          ),

        // 2- Navigate to [Contact page]  -> by using  [ .push() ] method type [ the default back arrow button will be dispalyed after each navigation process using this method   ]   :
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Go to Contact page '),
              onPressed: () {
                Navigator.of(
                  contex,
                ).push(MaterialPageRoute(builder: (contex) => Contact()));
              },
            ),
          ),



        ],
      ),
    );
  }
}
