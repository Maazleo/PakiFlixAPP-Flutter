import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final String response = await rootBundle.loadString('assets/details.json');
    final data = await json.decode(response);

    setState(() {
      allItems = [
        ...List<Map<String, dynamic>>.from(data['recent']),
        ...List<Map<String, dynamic>>.from(data['movies']),
        ...List<Map<String, dynamic>>.from(data['webSeries']),
        ...List<Map<String, dynamic>>.from(data['top10InPakistan']),
      ];
      isLoading = false;
    });
  }

  void _search(String query) {
    final results = allItems.where((item) {
      final title = item['title'].toLowerCase();
      final input = query.toLowerCase();
      return title.contains(input);
    }).toList();

    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.green[900],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search for a movie or series...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: searchResults.isEmpty && _searchController.text.isEmpty
                ? const Center(
              child: Text(
                'Type to start searching',
                style: TextStyle(color: Colors.white),
              ),
            )
                : searchResults.isEmpty
                ? const Center(
              child: Text(
                'No results found',
                style: TextStyle(color: Colors.white),
              ),
            )
                : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final item = searchResults[index];
                return ListTile(
                  leading: Image.network(
                    item['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey,
                        child: const Center(
                          child: Icon(Icons.error, color: Colors.red),
                        ),
                      );
                    },
                  ),
                  title: Text(item['title']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
