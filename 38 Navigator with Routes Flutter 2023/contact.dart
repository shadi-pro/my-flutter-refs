// [conact] => a custom widget as a page to be imported from  antother files

// provided navigator buttons  by different methods    :
// a- navigate to  [ Home  page widget]  => using the {.pushRemoveUntil()} navigator method
// b- navigate to  [ Home  page widget]  => using the {.push()} navigator method
// c- navigate to  [ About  page widget]  => using the {.pushReplacement()} navigator method
// d- navigate to  [ Go back  ]  => using the {.pop()}  navigator method
// e- using  the defined routes inside button        


//  ------------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:project/about.dart';
import 'package:project/homepage.dart';

// creating  custom [statelesswidget] to be imported in another file       :
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

          // a- navigate to  [ Home  page widget]  => using the {defined route inisde hte main file  } navigator method
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Go to Home page using defined route '),
              onPressed: () {
                Navigator.of(
                  contex
                ).pushNamed("home");
              },
            ),
          ),

          // b- navigate to  [ Home  page widget]  => using the {.push()} navigator method
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Go to Home page '),
              onPressed: () {
                Navigator.of(contex).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (contex) => Homepage()),
                  (route) => false,
                );
              },
            ),
          ),

          // c- navigate to  [ About  page widget]  => using the {.pushReplacement()} navigator method
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Go to  About  page '),
              onPressed: () {
                Navigator.of(contex).pushReplacement(
                  MaterialPageRoute(builder: (contex) => About()),
                );
              },
            ),
          ),

          // d- navigate to  [ Go back  ]  => using the {.pop()}  navigator method
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
      ),
    );
  }
}
