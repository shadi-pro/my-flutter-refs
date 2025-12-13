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
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Center(child: ListView(children: [])),
    );
  }
}

class CustomSearch extends SearchDelegate<String> {
  // Define full data
  final List<String> username = ['shadi', 'sayed', 'mohamed', 'ahmed', 'ali'];

  // Get filtered results based on query
  List<String> get filteredList {
    if (query.isEmpty) {
      return username;
    }
    return username
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // 1. Build actions (right side of app bar)
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          // Clear the search query
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // 2. Build leading widget (left side of app bar)
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        // Close the search and return null
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // 3. Build results when user selects a suggestion
  @override
  Widget buildResults(BuildContext context) {
    final results = filteredList;

    if (results.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
          onTap: () {
            // Close search and return selected value
            close(context, results[index]);
          },
        );
      },
    );
  }

  // 4. Build suggestions as user types
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = filteredList;

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            // Set query to the selected suggestion
            query = suggestions[index];
            // Show results
            showResults(context);
          },
        );
      },
    );
  }
}
