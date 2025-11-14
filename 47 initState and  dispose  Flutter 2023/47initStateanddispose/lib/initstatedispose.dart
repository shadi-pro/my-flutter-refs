/* {initstatedispose.dart}  => inner page of each dynamic selected product from {homepage}  inner page  :
  - some practical apps on usage of both of   [initSatate() ] &  [ dispose() ]           
  - differences between the   [initSatate() ] &  [ dispose() ]  :
    a- [ initSatate()  ]  =>   looping in a defined list with of scroling      
    b- [ dispose() ]  =>  looping in a defined list with of + defualt scroling       
 
 
*/

import 'package:flutter/material.dart';

class InitStateDispose extends StatefulWidget {
  const InitStateDispose({super.key});

  @override
  State<InitStateDispose> createState() => _InitStateDisposeState();
}

class _InitStateDisposeState extends State<InitStateDispose> {
  //  using the initial state to display a message before page  load being loaded ;
  @override
  void initState() {
    print('====================  Welcome to InitStateDispose page ');
    super.initState();
  }

  // using the [dispose]  to display a message after this  page is  being removed from pages qeue [incase of using navigation to homepage (that used {pushNamedAndRemoveUntil} method ) ]  ;
  @override
  void dispose() {
    print(
      '====================  Good bye to InitStateDispose page after being unloaded due to using [ pushNamedAndRemoveUntil ] navigation method  ',
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Initial State and Dispose Inner page ',
          style: TextStyle(color: Colors.black),
        ),

        iconTheme: IconThemeData(color: Colors.grey[800]),
        backgroundColor: Colors.grey[200],
        elevation: 0.0,
      ),

      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        selectedItemColor: Colors.orange,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: "Shopping",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "Setting",
          ),
        ],
      ),

      body: ListView(
        children: [
          MaterialButton(
            onPressed: () => Navigator.of(context).pushNamed('contact'),
            child: Text("Go to Contact page "),
          ),

          MaterialButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil("homepage", (route) => false);
            },
            child: Text("Go to Home page"),
          ),
        ],
      ),
    );
  }
}
