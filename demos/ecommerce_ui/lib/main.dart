/*  [ E-commerce] project :
  - UI flutter design of a close real project  with same functionalities of real  E-commerce project   
  - This proejct will be applied wit real api and backend side  withrfuturistic versions    
   
   
   
   A]  project structure :







  // -----------------------------------
  B]  Project Features :




  // -----------------------------------
  C]




*/
//===================================================

import 'package:flutter/material.dart';
import 'pages/homepage.dart';

void main() {
  runApp(const EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shadi Ecommerce Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Homepage(),
    );
  }
}
