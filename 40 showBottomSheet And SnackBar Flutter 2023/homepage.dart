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
  // A] public definitions  :

  // scffold key to be used in both   [showbottombar ] *  [snackbar]
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  //  construction function  :
  // const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,

      appBar: AppBar(title: const Text('Home Page')),

      body: ListView(
        children: [
          const Center(
            child: Text(
              ' {ShowBottomSheet}   & {SnackBar}',
              style: TextStyle(fontSize: 30),
            ),
          ),

          // 1-  Button for Controling the [showBottomSheet]:
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('show BottomSheet  '),
              onPressed: () {
                scaffoldKey.currentState!.showBottomSheet( (context) =>   
                  Container(
                    width : 1000 ,
                    height : 100 ,
                    color: Colors.blue,  // [ background color of  Bottomsheet  ] :
                    child :  Column( 
                      crossAxisAlignment: CrossAxisAlignment.start ,   // [ set the wide alignment]
                       
                      children:   [  
                        Text('Choose image from following :  ' ,   style : TextStyle(fontSize : 25 )   ), 
                        Container( height: 10  ), //  [ empty container as divider ]   
                        Text('Gallery' ,   style : TextStyle(fontSize : 20 , color: Colors.white ) ), 
                        Text('Images' ,   style : TextStyle(fontSize : 20, color: Colors.white ) ), 
                      ],             
                    )   
                   )   
                );
              },
            ),
          ),



          // 2-  Button for Controling the [ SnackBar]:
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('SnackBar'),
              onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        // animation: ,

                      backgroundColor: Colors.green ,                  
                      content: Text("snack bar  message info  ") , 
                      duration: Duration ( seconds: 3)  , 
                      action: SnackBarAction(label:'ok' , onPressed: () {
                        print("clicked on ok! "); 
                      } ) , 
                )) ;
              },
            ),
          ),



          // 1- display [showdialog]  button :
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Show Alert '),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible:
                      true, // [ ability of being canceled when click outside ]
                  builder: (context) {
                    return AlertDialog(
                      title: Text(' Warning ! '),
                      titlePadding: EdgeInsets.all(10),
                      titleTextStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),

                      content: Text(
                        ' Do you want to close this  dialog box  ? ',
                      ),
                      contentPadding: EdgeInsets.all(50),
                      contentTextStyle: TextStyle(fontSize: 15),

                      icon: Icon(
                        Icons.person,
                      ), // [  icon will be as title upper of  title ]
                      iconColor:
                          Colors
                              .white, // [  icon will be as title upper of  title ]

                      actions: [
                        // [ represent the available options buttons for this alert diaog  ]
                        TextButton(
                          onPressed: () {
                            print('ok');
                          },
                          child: Text('OK'),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pop(); // [this navgation process considered as back button  or cancel process ]
                          },
                          child: Text('NO'),
                        ),
                      ],

                      //  [determine the main alert dialog external shape ] :
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),

                      // elevation:  ,   // [shadow of alert dialog]
                      backgroundColor:
                          Colors
                              .red, //[backgrojdn color  for  whole alert dilaog ,  this property can be used in other features   ]
                    );
                  },
                );
              },
            ),
          ),

          // 2- Navigate to [About page] -> by using  [ .pushReplacement() ] ] method type [NO back arrow button will be dispalyed after navigation process ] :
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text(
                'click to display the [About] button  using  [ .pushReplacement() ] ',
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => About()),
                );
              },
            ),
          ),

          // 3- Navigate to [  about   page] -> by using  [ .push() ] ] method type [NO back arrow button will be dispalyed after navigation process ] :
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text(
                'click to go to  [About] buton using  [ .push() ] ',
              ),
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => About()));
              },
            ),
          ),

          // 4- Navigate to [ contact  page] -> by using  [ .push() ] ] method type [NO back arrow button will be dispalyed after navigation process ] :
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text(
                'click to go to [ contact  page] usging [.push()  ]  ',
              ),
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => Contact()));
              },
            ),
          ),

          // 5- Navigate to [contact  page] -> by using  [ .pushReplacement() ] ] method type [NO back arrow button will be dispalyed after navigation process ] :
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text(
                'click to go  to  [contact  page]  using  [ .pushReplacement()  ] ',
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Contact()),
                );
              },
            ),
          ),

          // 6-  [main page ]  -> by using  [ .pushRemoveUntil() ] method   :
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text(
                'click to go  to  [main page]  using  [.pushAndRemoveUntil() ] ',
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Homepage()),
                  (route) => false,
                );
              },
            ),
          ),

          // 7-  [Back button]  -> by using  [ .pop() ]  method  :
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('click to go back '),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
