import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AuthRepository(this._auth, this._db);

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  Future<UserCredential> signUp(String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> saveUsername({required String uid, required String username}) async {
    final normalized = username.toLowerCase();
    final usernameRef = _db.collection('usernames').doc(normalized);
    final userRef = _db.collection('users').doc(uid);

    await _db.runTransaction((tx) async {
      final existing = await tx.get(usernameRef);
      if (existing.exists && existing.data()?['uid'] != uid) {
        throw Exception('Username already taken');
      }
      tx.set(usernameRef, {'uid': uid, 'createdAt': FieldValue.serverTimestamp()});
      tx.set(userRef, {'username': normalized}, SetOptions(merge: true));
    });
  }
}
