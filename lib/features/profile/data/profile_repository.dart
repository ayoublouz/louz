import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/app_user.dart';

class ProfileRepository {
  ProfileRepository(this._db);
  final FirebaseFirestore _db;

  Stream<AppUser?> watchProfile(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return AppUser.fromMap(doc.data()!);
    });
  }

  Future<void> upsertProfile({
    required String uid,
    required String email,
    required String username,
    required String bio,
    required String quote,
    required String interestsSummary,
    required String themeId,
  }) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'username': username,
      'bio': bio,
      'quote': quote,
      'interestsSummary': interestsSummary,
      'themeId': themeId,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
