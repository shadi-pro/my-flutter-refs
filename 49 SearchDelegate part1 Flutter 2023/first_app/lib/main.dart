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
      title: 'Shadi first app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Shadi first app Home Page'),
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
        title: const Text('Search delegate part 1'),
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
  // a- add some [list of actions   - after search bar- ] for the [Search delegate], including  :
  // 1- close button [usgin a builtin method ]
  // 2- defiend query [ to store value of the search value ]

  @override
  List<Widget>? buildActions(BuildContext context) {
    query =
        ""; // search storing variable [considered as the text editing controller]

    return [
      IconButton(
        onPressed: () {
          close(context, null); //  [Built-in method for close]
        },
        icon: Icon(Icons.close),
      ),
    ]; // closing button [  bu this button will empty inside value of {query}  ]
  }

  // b- to add a leading action (action before search bar) for the [Search delegate] :
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back));
  }

  // c- to add some a  searching sugeestions for the [Search delegate] :
  @override
  Widget buildResults(BuildContext context) {
    return Text('');
  }

  // d- to add some a searching result  content for the [Search delegate] :
  @override
  Widget buildSuggestions(BuildContext context) {
    return Text('');
  }
}
