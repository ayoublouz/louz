import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../shared/models/gallery_item.dart';

class GalleryRepository {
  GalleryRepository(this._db, this._storage);
  final FirebaseFirestore _db;
  final FirebaseStorage _storage;

  Future<void> upload({required String uid, required File file, required String caption}) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = _storage.ref('users/$uid/gallery/$fileName.jpg');
    await ref.putFile(file);
    final url = await ref.getDownloadURL();

    await _db.collection('users').doc(uid).collection('gallery').add({
      'imageUrl': url,
      'caption': caption,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Stream<List<GalleryItem>> watch(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('gallery')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((s) => s.docs.map((d) => GalleryItem.fromMap(d.id, d.data())).toList());
  }
}
