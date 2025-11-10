  //  {details.dart}  [ItemDetails] inner page  =>  to be called insde the {main.dart} within   [scaffold] : 'home'       


//  a custom widget as a [item details page]  of project [E-commerce] , to be imported inside the [main.dart]
//  this  custom widget [item details]  page  will recieve data [dataitem ] from the [ Homepage] for each product

//  Screen Contents  => Container of [Listview] including next elements :
  // 

 
 
 
// -------------------------------------

import 'package:flutter/material.dart';
// import 'package:project/contact.dart';


// creating  custom [statefulwidget] to be imoprted in another file :

class ItemDetails extends StatefulWidget {
  
  // define the property(s) to be recieved from [home page] as final  :  
   final dataitem ;  


  // add define the property(s) into  construtor function    of [ItemDetails] :  
  const ItemDetails({super.key , this.dataitem});
  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}
// -------
// ------------------------------------

class _ItemDetailsState extends State<ItemDetails> {
  // A] public definitions  :
 
  //  -------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // 1- setting the [app bar] properites   :  
      appBar: AppBar(
        //  building the halved text using   [row] of (2) text  :

        title : const  Row (
          mainAxisAlignment: MainAxisAlignment.center ,
          
          children: [
            Icon(Icons.shop_outlined , color: Colors.black  ) , 
            Text(' Shadi ' ,  style: TextStyle(color : Colors.black )   ) ,  
            Text(' E-commerce' ,  style: TextStyle(color : Colors.orange )   ) ,  
          ], 
           
        ) , 


        // centerTitle : true ,  //  [not needed when using a row as a title  ]

        //  controling the appbar icon color :  
        iconTheme: const  IconThemeData( 
           color : Colors.grey 
        ) , 

        backgroundColor: Colors.grey[200] ,
        elevation:  0.0 ,     // [ remove the elevation effect]
      ),
 

      // 2- setting the [Drawer] :
        endDrawer: const Drawer(
        ) , 

      // BottomNavigationBar section  :
      bottomNavigationBar: BottomNavigationBar( 
        iconSize: 40,
        
        selectedItemColor:  Colors.orange   ,

        //   main icons inside bottom navigation bar     :         
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined ) , label: '*' ) , 
          BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined ) , label: '*' ) , 
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined ) , label: '*' ) , 
        ] , 
      ) ,
      
      
      // appBar: AppBar(title: const Text('Home Page of E-commerce project ')),
      body: Container(
        padding: EdgeInsets.all(20),

        child: ListView(
          children: [
            Image.asset( widget.dataitem['image']) ,  // [using one of recived data variable from [Homepepge] + using the {widget} due to using indirect class  ]
          ]         
        ),
      ),
    );
  }
}


 