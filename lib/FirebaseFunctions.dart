
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'MoviesClass.dart';

class FirebaseFunctions {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference moviesCollection =
  FirebaseFirestore.instance.collection('movies');

  Future<void> uploadMovie(Movie movie) async {
    try {
      await moviesCollection.add(movie.toMap());
      print('Movie uploaded successfully!');
    } catch (e) {
      print('Error uploading movie: $e');
   }
  }

}
