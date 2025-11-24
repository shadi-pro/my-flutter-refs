/* [homepage] =>
   - a  Home page  including  usiage of the mehtod of search deleagate  inside the  [AppBar]
    
*/
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

        //  thi will inlude  seadch delegate inside [icon button] :
        actions: [
          // activate the searching delegate by press this button :
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                // the delegate property will class the defined class
                delegate: CustomSearch(),
              );
            },
          ),
        ],
      ),

      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              textAlign: TextAlign.center,
              "This lesson is group of tools [ functions +  variables ] in flutter to execute a proffient customized searching , usually related to buttons widgets ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),

          SizedBox(height: 50),

          Container(
            alignment: Alignment.center,
            child: Text(
              textAlign: TextAlign.center,
              "This lesson is  being applied in this  lesson",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),

          // MaterialButton(
          //   onPressed: () => Navigator.of(context).pushNamed('popupmenubutton'),
          //   child: Text(
          //     "Go to Lesson page of [Popup Menu button ]",
          //     style: TextStyle(fontWeight: FontWeight.bold),
          //   ),
          // ),

          // MaterialButton(
          //   onPressed: () => Navigator.of(context).pushNamed('listgenerate'),
          //   child: Text(
          //     "Go to Lesson page [Initial State and Dispose]",
          //     style: TextStyle(fontWeight: FontWeight.bold),
          //   ),
          // ),
        ],
      ),
    );
  }
}
// ---------------------------------------------

// building a seperate class for search delegate :
class CustomSearch extends SearchDelegate {
  // first button [prefix] inside the sreaching bar => will be customized as [Clearing] function :
  @override
  List<Widget>? buildActions(BuildContext context) {
    // return list of actions functions      :
    return [
      IconButton(
        onPressed: () {
          query =
              ''; // [a built-in serching delegate contorling] -> by click this button => search delegate bar value will be set by empty value [querry]
        },
        icon: Icon(Icons.close),
      ),
    ];
  }

  //  End button [suffix]  inside the searcing bar => => will be customized as [Close] function :
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(
          context,
          null,
        ); // [ built-in   methiod of closing searching dalegate ]
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  // display the searching  grid  result    :
  @override
  Widget buildResults(BuildContext context) {
    return Text('Seraching result');
  }

  //Return context value    :
  @override
  Widget buildSuggestions(BuildContext context) {
    return Text('Context');
  }
}
