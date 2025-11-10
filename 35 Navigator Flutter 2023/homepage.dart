// [homepage] => 
//  a custom widget as a page  to be imported from antother files
// provided with button of    navigator  to [About  widget] 

import 'package:flutter/material.dart';
import 'package:project/about.dart';

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

          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Go to About page '),
              onPressed: () {
                Navigator.of(
                  contex,
                ).push(MaterialPageRoute(builder: (contex) => About()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
