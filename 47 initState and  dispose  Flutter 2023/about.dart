// [about] => a custom widget as a page to be imported from  antother files
 // provided with button of    navigator  to [Homepage  widget]  



import 'package:flutter/material.dart';
import 'package:project/homepage.dart';
import 'package:project/contact.dart';

// creating  custom [statelesswidget] to be imoprted in another file       :
class About extends StatelessWidget {
  //  construction function  :
  const About({super.key});

  @override
  Widget build(BuildContext contex) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Page')),

      body: ListView(
        children: [
          const Center(
            child: Text('About Page', style: TextStyle(fontSize: 30)),
          ),

        // 1- Navigate to home  page [usign the {.pop()}  method     ]:
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Go Back  '),
              onPressed: () {
                Navigator.of(contex).pop();
              },
            ),
          ), 
          
                   
        // 2- Navigate to contact page :
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Go to Contact page '),
              onPressed: () {
                Navigator.of(contex).push(MaterialPageRoute(builder: (contex) => Contact() ));
              },
            ),
          ),          
        ],
      )
    );
  }
}
