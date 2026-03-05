import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/todo_item.dart';

class TodoRepository {
  TodoRepository(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('todos');

  Stream<List<TodoItem>> watch(String uid) {
    return _col(uid).orderBy('title').limit(100).snapshots().map(
          (s) => s.docs.map((d) => TodoItem.fromMap(d.id, d.data())).toList(),
        );
  }

  Future<void> add(String uid, String title) => _col(uid).add({'title': title, 'done': false});
  Future<void> toggle(String uid, TodoItem item) => _col(uid).doc(item.id).update({'done': !item.done});
  Future<void> remove(String uid, String id) => _col(uid).doc(id).delete();
}
