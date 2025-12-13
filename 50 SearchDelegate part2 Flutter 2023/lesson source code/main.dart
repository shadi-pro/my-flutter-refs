import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Searching Delegate part2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Searching Delegate part2'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search delegate part 2'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearch());
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),

      body: Center(child: ListView(children: [])),
    );
  }
}

// building a customSearch class that extneding form the main built-in {SearchDelegate} requrid for searcing delegate   :
class CustomSearch extends SearchDelegate {
  // define a simuation list to be used as searhing [full suggestions] source [instead of using a real api] :
  List username = ['shadi', 'sayed', 'mohamed', 'ahmed', 'ali'];

  // define a simuation list to be used as searhing [full suggestions] source [instead of using a real api] :
  List? filterlist;

  // -- add some [list of actions   - after search bar- ] for the [Search delegate], including  :
  // 1- close button [usgin a builtin method ]
  // 2- defiend query [ to store value of the search value ]

  @override
  List<Widget>? buildActions(BuildContext context) {
    // search storing variable [considered as the text editing controller]
    query = "";

    return [
      IconButton(
        onPressed: () {
          close(context, null); //  [Built-in method for close]
        },
        icon: Icon(Icons.close),
      ),
    ]; // closing button [clicking this button will empty inside value of {query}  ]
  }

  // b- to add a leading action (action before search bar) for the [Search delegate] :
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back));
  }

  // c- to add some a  searching suggestions for the [Search delegate] :
  @override
  Widget buildResults(BuildContext context) {
    return Text('Result : $query');
  }

  // d- to add some searching result content for the [Search delegate] (using a defiene list ) :
  @override
  Widget buildSuggestions(BuildContext context) {
    // [displaying all the defined list's items of searchging suggestions  if the serachgin queryis empty ] :
    if (query == "") {
      return ListView.builder(
        itemCount: username.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              showResults(
                context,
              ); // [ using the built in method of the showResult() existed inside the metod of {buildResults} ]
            },

            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text("${username[i]}", style: TextStyle(fontSize: 16)),
              ),
            ),
          );
        },
      );
    } else {
      // assigned filterd value of main  list inside a filterd list  if the 'query' has a value -> then filter the defined list according to the inserted value contiaining partial vlaue of one main list's elements :
      filterlist = username
          .where(
            (element) => element.startsWith(query),
          ) // [ can use other keyworkd of flitering ( contains , startsWith , endsWith) ]
          .toList();
      return ListView.builder(
        itemCount: filterlist!.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              showResults(
                context,
              ); // [ using the built in method of the showResult() existed  inside  the metod of {buildResults} ]
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "${filterlist![i]}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
