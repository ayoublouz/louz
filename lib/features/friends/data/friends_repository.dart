import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/friend_request.dart';

class FriendsRepository {
  FriendsRepository(this._db);
  final FirebaseFirestore _db;

  Future<String?> uidByUsername(String username) async {
    final doc = await _db.collection('usernames').doc(username.toLowerCase()).get();
    return doc.data()?['uid'] as String?;
  }

  Future<void> sendRequest({
    required String fromUid,
    required String fromUsername,
    required String toUid,
  }) async {
    await _db.collection('friendRequests').add({
      'fromUid': fromUid,
      'fromUsername': fromUsername,
      'toUid': toUid,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<FriendRequest>> incomingRequests(String uid) {
    return _db
        .collection('friendRequests')
        .where('toUid', isEqualTo: uid)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((s) => s.docs.map((d) => FriendRequest.fromMap(d.id, d.data())).toList());
  }

  Future<void> acceptRequest(FriendRequest request) async {
    final aRef = _db.collection('users').doc(request.fromUid).collection('friends').doc(request.toUid);
    final bRef = _db.collection('users').doc(request.toUid).collection('friends').doc(request.fromUid);
    final reqRef = _db.collection('friendRequests').doc(request.id);

    await _db.runTransaction((tx) async {
      tx.set(aRef, {
        'uid': request.toUid,
        'circle': 'close_friends',
        'createdAt': FieldValue.serverTimestamp(),
      });
      tx.set(bRef, {
        'uid': request.fromUid,
        'circle': 'close_friends',
        'createdAt': FieldValue.serverTimestamp(),
      });
      tx.update(reqRef, {'status': 'accepted'});
    });
  }

  Stream<List<Map<String, dynamic>>> friends(String uid) {
    return _db.collection('users').doc(uid).collection('friends').snapshots().map(
          (s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList(),
        );
  }

  Future<void> assignCircle({required String uid, required String friendUid, required String circle}) {
    return _db.collection('users').doc(uid).collection('friends').doc(friendUid).set(
      {'circle': circle, 'updatedAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }
}
