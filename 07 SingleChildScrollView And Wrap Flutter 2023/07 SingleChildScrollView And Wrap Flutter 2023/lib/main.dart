/*
 Lessons applied in this application :  
   1- [Text] widget 
   2- [Container]  widget 
   3- [Image] widget
   4- [Column] & [Row] widget
   5- [Wrap] widget & [SingleChildScrollView] Widget  => this lesson    

   // This app descrption   :
      -- design a main  [column] container scroling vertically ,aned include several [rows & Wraps] that can scroling horizonalty             

      - SingleChildScrollView [vertical axis ]   : 
        --  SingleChildScrollView [horizontal axis ]   : 
          --- Column : 
            ---- Rows[6] + Wraps[3] , each one include severeal children  :     
              ----- Containers[5]   
*/
// --------------------------

// import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('[Wrap] widget and [SingleChildScrollView] widget'),
        ),

        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(width: 200, height: 100, color: Colors.red),
                    Container(width: 200, height: 100, color: Colors.blue),
                    Container(width: 200, height: 100, color: Colors.green),
                    Container(width: 200, height: 100, color: Colors.brown),
                    Container(width: 200, height: 100, color: Colors.yellow),
                  ],
                ),
                Row(
                  children: [
                    Container(width: 200, height: 100, color: Colors.yellow),
                    Container(width: 200, height: 100, color: Colors.green),
                    Container(width: 200, height: 100, color: Colors.red),
                    Container(width: 200, height: 100, color: Colors.blue),
                    Container(width: 200, height: 100, color: Colors.brown),
                  ],
                ),
                Row(
                  children: [
                    Container(width: 200, height: 100, color: Colors.blue),
                    Container(width: 200, height: 100, color: Colors.red),
                    Container(width: 200, height: 100, color: Colors.brown),
                    Container(width: 200, height: 100, color: Colors.green),
                    Container(width: 200, height: 100, color: Colors.yellow),
                  ],
                ),
                Row(
                  children: [
                    Container(width: 200, height: 100, color: Colors.red),
                    Container(width: 200, height: 100, color: Colors.blue),
                    Container(width: 200, height: 100, color: Colors.yellow),
                    Container(width: 200, height: 100, color: Colors.brown),
                    Container(width: 200, height: 100, color: Colors.green),
                  ],
                ),
                Row(
                  children: [
                    Container(width: 200, height: 100, color: Colors.red),
                    Container(width: 200, height: 100, color: Colors.brown),
                    Container(width: 200, height: 100, color: Colors.blue),
                    Container(width: 200, height: 100, color: Colors.green),
                    Container(width: 200, height: 100, color: Colors.yellow),
                  ],
                ),
                Row(
                  children: [
                    Container(width: 200, height: 100, color: Colors.green),
                    Container(width: 200, height: 100, color: Colors.red),
                    Container(width: 200, height: 100, color: Colors.blue),
                    Container(width: 200, height: 100, color: Colors.brown),
                    Container(width: 200, height: 100, color: Colors.yellow),
                  ],
                ),

                Wrap(
                  children: [
                    Container(width: 200, height: 100, color: Colors.green),
                    Container(width: 200, height: 100, color: Colors.red),
                    Container(width: 200, height: 100, color: Colors.blue),
                    Container(width: 200, height: 100, color: Colors.brown),
                    Container(width: 200, height: 100, color: Colors.yellow),
                  ],
                ),

                Wrap(
                  children: [
                    Container(width: 200, height: 100, color: Colors.green),
                    Container(width: 200, height: 100, color: Colors.red),
                    Container(width: 200, height: 100, color: Colors.blue),
                    Container(width: 200, height: 100, color: Colors.brown),
                    Container(width: 200, height: 100, color: Colors.yellow),
                  ],
                ),

                Wrap(
                  children: [
                    Container(width: 200, height: 100, color: Colors.green),
                    Container(width: 200, height: 100, color: Colors.red),
                    Container(width: 200, height: 100, color: Colors.blue),
                    Container(width: 200, height: 100, color: Colors.brown),
                    Container(width: 200, height: 100, color: Colors.yellow),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//  --------------
  
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal ,
        //   child : Wrap(           
        //     direction: Axis.vertical,
        //     children: [  
        //       Container(  width:  200 , height:  100 , color:  Colors.red )  ,
        //       Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
        //       Container(  width:  200 , height:  100 , color:  Colors.green ) ,
        //       Container(  width:  200 , height:  100 , color:  Colors.green ) 
        //      ],
        //   ) , 
        // )      



          // Wrap(
          //   // direction: Axis.horizontal ,
          //   direction: Axis.vertical,
          //   children: [  
          //     Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //     Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //     Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //     Container(  width:  200 , height:  100 , color:  Colors.green ) 
          //    ],
          // ) , 




          //  SingleChildScrollView(
          //   scrollDirection: Axis.vertical,  
          //    child: Column(
            
          //       children : [
          //         Wrap(
          //           direction: Axis.horizontal ,
                    
          //           children: [
             
          //             SingleChildScrollView(
          //                 scrollDirection: Axis.vertical ,
          //                 child:  Column(
          //                   children: [
          //                     Column(  
          //                           children: [
          //                             Wrap( 
          //                               direction: Axis.vertical,
          //                               children: [  
          //                                 Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.brown ) 
          //                               ],
          //                             ) , 
                          
          //                             Wrap( 
          //                               direction: Axis.vertical,
          //                               children: [  
          //                                 Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.brown ) 
          //                               ],
          //                             ) , 
                          
          //                             Wrap( 
          //                               direction: Axis.vertical,
          //                               children: [  
          //                                 Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.brown ) 
          //                               ],
          //                             ) , 
                          
          //                           ],
          //                       ), 
                                  
          //                     Column(  
          //                           children: [
          //                             Wrap( 
          //                               direction: Axis.vertical,
          //                               children: [  
          //                                 Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.brown ) 
          //                               ],
          //                             ) , 
                          
          //                             Wrap( 
          //                               direction: Axis.vertical,
          //                               children: [  
          //                                 Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.brown ) 
          //                               ],
          //                             ) , 
                          
          //                             Wrap( 
          //                               direction: Axis.vertical,
          //                               children: [  
          //                                 Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.brown ) 
          //                               ],
          //                             ) , 
                          
          //                           ],
          //                       ), 
                                  
          //                     Column(  
          //                           children: [
          //                             Wrap( 
          //                               direction: Axis.vertical,
          //                               children: [  
          //                                 Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.brown ) 
          //                               ],
          //                             ) , 
                          
          //                             Wrap( 
          //                               direction: Axis.vertical,
          //                               children: [  
          //                                 Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.brown ) 
          //                               ],
          //                             ) , 
                          
          //                             Wrap( 
          //                               direction: Axis.vertical,
          //                               children: [  
          //                                 Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.brown ) 
          //                               ],
          //                             ) , 
                          
          //                           ],
          //                       ), 
             
          //                   ],          
                        
          //                 ),
          //             ),
              
              
          //             SingleChildScrollView(
          //                 scrollDirection: Axis.vertical ,
          //                 child:  Column(
          //                   children: [
          //                     Column(  
          //                           children: [
          //                             Wrap( 
          //                               direction: Axis.vertical,
          //                               children: [  
          //                                 Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.brown ) 
          //                               ],
          //                             ) , 
                          
          //                             Wrap( 
          //                               direction: Axis.vertical,
          //                               children: [  
          //                                 Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) 
          //                               ],
          //                             ) , 
                          
          //                             Wrap( 
          //                               direction: Axis.vertical,
          //                               children: [  
          //                                 Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.brown ) 
          //                               ],
          //                             ) , 
                          
          //                           ],
          //                       ), 
                                  
          //                     Column(  
          //                           children: [
          //                             Wrap( 
          //                               direction: Axis.vertical,
          //                               children: [  
          //                                 Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.brown ) 
          //                               ],
          //                             ) , 
                          
          //                             Wrap( 
          //                               direction: Axis.vertical,
          //                               children: [  
          //                                 Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.brown ) 
          //                               ],
          //                             ) , 
                          
          //                             Wrap( 
          //                               direction: Axis.vertical,
          //                               children: [  
          //                                 Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.brown ) 
          //                               ],
          //                             ) , 
                          
          //                           ],
          //                       ), 
                                  
          //                     Column(  
          //                           children: [
          //                             Wrap( 
          //                               direction: Axis.vertical,
          //                               children: [  
          //                                 Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.brown ) 
          //                               ],
          //                             ) , 
                          
          //                             Wrap( 
          //                               direction: Axis.vertical,
          //                               children: [  
          //                                 Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.brown ) 
          //                               ],
          //                             ) , 
                          
          //                             Wrap( 
          //                               direction: Axis.vertical,
          //                               children: [  
          //                                 Container(  width:  200 , height:  100 , color:  Colors.red )  ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.blue  ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.green ) ,
          //                                 Container(  width:  200 , height:  100 , color:  Colors.brown ) 
          //                               ],
          //                             ) , 
                          
          //                           ],
          //                       ), 
             
          //                   ],          
                        
          //                 ),
          //             ),
              
              
                    
          //           ],
          //         )   
          //       ] 
          //    ),
          //  )
