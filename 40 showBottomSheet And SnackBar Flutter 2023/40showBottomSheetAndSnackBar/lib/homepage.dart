// [homepage] =>
//  a custom widget as a page  to be imported from antother files
// provided with 2 buttons of navigator to:
//  1- [About page widget] =>  (using the {.pushReplacement} type)]
//  2- [Contact page widget] =>  (using the {.push} type)]

import 'package:flutter/material.dart';
import 'package:first_app/customcard.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: const [
        CustomCard(
          name: "Shadi Ahmed",
          email: "shadidev@gmail.com",
          date: "8 Nov 2025",
          imageName: "assets/images/shadi.jpg",
        ),
        CustomCard(
          name: "Ali Hassan",
          email: "ali@gmail.com",
          date: "5 Oct 2025",
          imageName: "assets/images/img1.jpg",
        ),
        CustomCard(
          name: "Omar Hussen",
          email: "Omargmail.com",
          date: "5 Oct 2025",
          imageName: "assets/images/img2.jpg",
        ),
        CustomCard(
          name: "Ahmed Hassan",
          email: "Ahmed@gmail.com",
          date: "5 Oct 2025",
          imageName: "assets/images/img3.jpg",
        ),
      ],
    );
  }
}
