import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/services/repository_providers.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Scaffold(body: Center(child: Text('No user')));
    final stream = ref.watch(todoRepositoryProvider).watch(uid);
    final ctrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Private to-do')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Expanded(child: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'New task'))),
            IconButton(
              onPressed: () async {
                await ref.read(todoRepositoryProvider).add(uid, ctrl.text.trim());
                ctrl.clear();
              },
              icon: const Icon(Icons.add),
            )
          ]),
        ),
        Expanded(
          child: StreamBuilder(
            stream: stream,
            builder: (_, snapshot) {
              final todos = snapshot.data ?? [];
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (_, i) => CheckboxListTile(
                  value: todos[i].done,
                  title: Text(todos[i].title),
                  onChanged: (_) => ref.read(todoRepositoryProvider).toggle(uid, todos[i]),
                  secondary: IconButton(
                    onPressed: () => ref.read(todoRepositoryProvider).remove(uid, todos[i].id),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ),
              );
            },
          ),
        )
      ]),
    );
  }
}
