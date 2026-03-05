import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/interest_item.dart';

class InterestsRepository {
  InterestsRepository(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('interests');

  Stream<List<InterestItem>> watch(String uid) {
    return _col(uid).orderBy('category').snapshots().map((s) =>
        s.docs.map((d) => InterestItem.fromMap(d.id, d.data())).toList());
  }

  Future<void> add(String uid, InterestItem item) async {
    await _col(uid).add({...item.toMap(), 'createdAt': FieldValue.serverTimestamp()});
  }

  Future<void> update(String uid, InterestItem item) async {
    await _col(uid).doc(item.id).set(item.toMap(), SetOptions(merge: true));
  }

  Future<void> delete(String uid, String id) => _col(uid).doc(id).delete();
}
