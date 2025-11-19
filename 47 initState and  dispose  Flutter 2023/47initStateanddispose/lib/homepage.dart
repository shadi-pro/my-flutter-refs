// [homepage] =>
//  a  Home page  inlcuding several buttons to be used in routing to inner pages of app
// provided with 2 buttons of navigator to:
//  0- [ {homepage.dart} ] =>  (using the {.pushReplacement} type)]
//  1- [ {initstatedispose.dart} ] =>  (using the {.pushReplacement} type)]
//  2- [ {contact.dart} ] =>  (using the {.pushReplacement} type)]

import 'package:flutter/material.dart';
// import 'package:first_app/customcard.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Home page', style: TextStyle(color: Colors.black)),

        iconTheme: IconThemeData(color: Colors.grey[800]),
        backgroundColor: Colors.grey[200],
        elevation: 0.0,
      ),

      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              textAlign: TextAlign.center,
              "This lesson is about the both of initState and dipose function in navigation as practical exmaple \n The main concept of {initState()} and {dipose()} methods as following :   ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),

          SizedBox(height: 50),

          Container(
            // decoration: border: Border(20),
            child: Text(
              textAlign: TextAlign.center,
              "{initState()} : void method to be executed before the load is being loaded \n  {dispose()} : void method to be executed after the load is being loaded  ",
              style: TextStyle(),
            ),
          ),

          MaterialButton(
            onPressed: () => Navigator.of(context).pushNamed('contact'),
            child: Text(
              "Go to Contact page",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          MaterialButton(
            onPressed: () => Navigator.of(context).pushNamed('listgenerate'),
            child: Text(
              "Go to Lesson page [Initial State and Dispose]",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
