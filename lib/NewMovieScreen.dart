import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CreateMovieScreen extends StatefulWidget {
  final Function() updateMoviesCallback;

  const CreateMovieScreen({super.key, required this.updateMoviesCallback});

  @override
  _CreateMovieScreenState createState() => _CreateMovieScreenState();
}

class _CreateMovieScreenState extends State<CreateMovieScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  Future<void> _addMovie() async {
    final String title = _titleController.text;
    final String imageUrl = _imageController.text;

    if (title.isEmpty || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and Image URL are required')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    const String moviesKey = 'movies';
    List<Map<String, dynamic>> moviesList = [];

    // Retrieve existing movies data
    final String? moviesJson = prefs.getString(moviesKey);
    if (moviesJson != null) {
      moviesList = List<Map<String, dynamic>>.from(json.decode(moviesJson));
    }

    // Add the new movie
    moviesList.add({
      'title': title,
      'image': imageUrl,
    });

    // Save updated movies list
    await prefs.setString(moviesKey, json.encode(moviesList));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Movie added successfully')),
    );

    // Clear the input fields
    _titleController.clear();
    _imageController.clear();

    // Update UI on the main screen
    widget.updateMoviesCallback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Movie'),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addMovie,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreenAccent,
              ),
              child: const Text('Add Movie'),
            ),
          ],
        ),
      ),
    );
  }
}
