import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'NewMovieScreen.dart';
import 'detailmodal.dart';
import 'my_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PakiFlixApp());
}

class PakiFlixApp extends StatefulWidget {
  const PakiFlixApp({super.key});

  @override
  State<PakiFlixApp> createState() => _PakiFlixAppState();
}

class _PakiFlixAppState extends State<PakiFlixApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PakiFlix',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SplashScreen(), // Set splash screen as home initially
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to main screen after a delay
    Timer(
      const Duration(seconds: 2), // Set the duration for splash screen display
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.green, // Set your desired background color
      body: Center(
        child: Image.asset(
          'assets/logo.png', // Your app logo or splash screen image
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> recent = [];
  List<Map<String, dynamic>> movies = [];
  List<Map<String, dynamic>> webSeries = [];
  List<Map<String, dynamic>> top10InPakistan = [];
  Map<String, dynamic> details = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String response = await rootBundle.loadString('assets/details.json');
    final data = await json.decode(response);

    setState(() {
      recent = List<Map<String, dynamic>>.from(data['recent']);
      webSeries = List<Map<String, dynamic>>.from(data['webSeries']);
      top10InPakistan = List<Map<String, dynamic>>.from(data['top10InPakistan']);
      details = Map<String, dynamic>.from(data['details']);
    });

    // Load movies from SharedPreferences
    final String? moviesJson = prefs.getString('movies');
    if (moviesJson != null) {
      setState(() {
        movies = List<Map<String, dynamic>>.from(json.decode(moviesJson));
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showDetails(BuildContext context, String title) {
    final detail = details[title];
    if (detail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No details available for $title')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DetailModal(detail: detail);
      },
    );
  }

  Widget _buildRow(List<Map<String, dynamic>> items, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () => _showDetails(context, item['title']),
                child: Container(
                  width: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
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
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item['title'],
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(40),
              child: Image.asset(
                'assets/logo.png',
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            _buildRow(recent, 'Recent'),
            _buildRow(movies, 'Movies'),
            _buildRow(webSeries, 'Web Series'),
            _buildRow(top10InPakistan, 'Top 10 in Pakistan')
          ],
        ),
      ),
      CreateMovieScreen(updateMoviesCallback: _loadData), // Updated to include callback
      const MyListPage(), // My List Page
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PakiFlix',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.green[900],
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.list, color: Colors.white),
            onPressed: () {
              setState(() {
                _selectedIndex = 2;
              });
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
        backgroundColor: Colors.green[900],
        child: const Icon(Icons.list, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add New',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'My List',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}
