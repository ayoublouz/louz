import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/interest_item.dart';
import '../../../shared/services/repository_providers.dart';

class InterestsScreen extends ConsumerWidget {
  const InterestsScreen({super.key});

  static const categories = [
    'movies',
    'books',
    'music',
    'games',
    'sports',
    'celebrities',
    'travel',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Scaffold(body: Center(child: Text('No user')));

    final stream = ref.watch(interestsRepositoryProvider).watch(uid);

    return Scaffold(
      appBar: AppBar(title: const Text('Interests')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditor(context, ref, uid),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final item = items[i];
              return ListTile(
                title: Text(item.title),
                subtitle: Text('${item.category} • ${item.note}'),
                onTap: () => _showEditor(context, ref, uid, existing: item),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => ref.read(interestsRepositoryProvider).delete(uid, item.id),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showEditor(BuildContext context, WidgetRef ref, String uid, {InterestItem? existing}) async {
    final title = TextEditingController(text: existing?.title ?? '');
    final note = TextEditingController(text: existing?.note ?? '');
    String category = existing?.category ?? categories.first;

    await showModalBottomSheet(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButton<String>(
              value: category,
              isExpanded: true,
              items: categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setSheetState(() => category = v!),
            ),
            TextField(controller: title, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: note, decoration: const InputDecoration(labelText: 'Note')),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                final item = InterestItem(
                  id: existing?.id ?? '',
                  category: category,
                  title: title.text.trim(),
                  note: note.text.trim(),
                );
                if (existing == null) {
                  await ref.read(interestsRepositoryProvider).add(uid, item);
                } else {
                  await ref.read(interestsRepositoryProvider).update(uid, item);
                }
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Save'),
            )
          ]),
        ),
      ),
    );
  }
}
