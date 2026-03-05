import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../shared/models/checkin_entry.dart';

class CheckinRepository {
  CheckinRepository(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('checkins');

  static String todayId() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> saveToday(String uid, CheckinEntry entry) async {
    await _col(uid).doc(entry.dateId).set({
      ...entry.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<CheckinEntry?> watchToday(String uid) {
    return _col(uid).doc(todayId()).snapshots().map((d) {
      if (!d.exists || d.data() == null) return null;
      return CheckinEntry.fromMap(d.id, d.data()!);
    });
  }

  Stream<List<CheckinEntry>> history(String uid) {
    return _col(uid)
        .orderBy(FieldPath.documentId, descending: true)
        .limit(30)
        .snapshots()
        .map((s) => s.docs.map((d) => CheckinEntry.fromMap(d.id, d.data())).toList());
  }
}
