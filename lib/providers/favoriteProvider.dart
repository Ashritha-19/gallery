import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  /// Check if image already favorite
  Future<bool> isFavorite(String imageId) async {
    final doc = await _firestore
        .collection('favorites')
        .doc(userId)
        .collection('images')
        .doc(imageId)
        .get();

    return doc.exists;
  }

  /// Add favorite
  Future<void> addFavorite(Map<String, dynamic> data) async {
    await _firestore
        .collection('favorites')
        .doc(userId)
        .collection('images')
        .doc(data['id']) // prevents duplicates
        .set(data);
  }

  /// Remove favorite
  Future<void> removeFavorite(String id) async {
    await _firestore
        .collection('favorites')
        .doc(userId)
        .collection('images')
        .doc(id)
        .delete();
  }

  /// Real-time favorites
  Stream<QuerySnapshot> getFavorites() {
    return _firestore
        .collection('favorites')
        .doc(userId)
        .collection('images')
        .snapshots();
  }
}
