import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToFavorites({
    required String userId,
    required Map<String, dynamic> imageData,
    required String imageId,
  }) async {
    await _firestore
        .collection('favorites')
        .doc(userId)
        .collection('images')
        .doc(imageId)
        .set(imageData);
  }

  Future<void> removeFromFavorites({
    required String userId,
    required String imageId,
  }) async {
    await _firestore
        .collection('favorites')
        .doc(userId)
        .collection('images')
        .doc(imageId)
        .delete();
  }

  Stream<QuerySnapshot> getFavorites(String userId) {
    return _firestore
        .collection('favorites')
        .doc(userId)
        .collection('images')
        .snapshots();
  }
}
