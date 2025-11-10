
// [conact] => a custom widget as a page to be imported from  antother files

 // provided navigator buttons  by different methods    : 
 //  navigate to  [ Home  page widget]  => using the {.push()} navigator method    
 //  navigate to  [ About  page widget]  => using the {.pushReplacement()} navigator method  
 //  navigate to  [ Go back  ]  => using the {.pop()}  navigator method  
//  ------------------------------------------------------------------------------------------------------
  



import 'package:flutter/material.dart';
import 'package:project/about.dart';
import 'package:project/homepage.dart';

// creating  custom [statelesswidget] to be imoprted in another file       :
class Contact extends StatelessWidget {
  //  construction function  :
  const Contact({super.key});

  @override
  Widget build(BuildContext contex) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Page')),

      body: ListView(
        children: [
          const Center(
            child: Text('Contact  Page', style: TextStyle(fontSize: 30)),
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Go to Home page '),
              onPressed: () {
                Navigator.of(contex).push(MaterialPageRoute(builder: (contex) => Homepage() ));
              },
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Go to  About  page '),
              onPressed: () {
                Navigator.of(contex).pushReplacement(MaterialPageRoute(builder: (contex) =>  About() ));
              },
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Go to back'),
              onPressed: () {
                Navigator.of(contex).pop();
              },
            ),
          ),          
        ],
      )
    );
  }
}
