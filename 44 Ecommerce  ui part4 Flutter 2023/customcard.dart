


// Creating new stateless custom widget [to be used insde another widget ] :
import 'package:flutter/material.dart';

class CustomListtile extends StatelessWidget {
  // 1- define variables :
  final String name;
  final String email;
  final String date;
  final String imagename;

  // 2- define the construtor including upper defined variables    :
  const CustomListtile({super.key, required this.name, required this.email,  required this.date, required  this.imagename});

  // 3- building  custom widget  :
  @override
  Widget build(BuildContext context) {
    
    // Creating [Card] widget including [ListTile] manually   :
    return               
      Card(
        color: Colors.red , // [this formating property will be applied oin all called custom widgets ]                
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(  
                height: 100,
                width: 100,
                child:  ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset( "$imagename"  ,  fit: BoxFit.cover ) ,   
                )            
              ), 
          
              Expanded(
                child:
                  ListTile(
                  title: Text("$name"),
                  subtitle: Text("$email"),
                  trailing: Text("$date"),
                ),    
              ) 
            ],
          ),
        )   
      ) ; 
  }  
  
}
