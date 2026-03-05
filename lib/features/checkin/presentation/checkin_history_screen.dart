import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/services/repository_providers.dart';

class CheckinHistoryScreen extends ConsumerWidget {
  const CheckinHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Scaffold(body: Center(child: Text('No user')));
    final stream = ref.watch(checkinRepositoryProvider).history(uid);

    return Scaffold(
      appBar: AppBar(title: const Text('Check-in history')),
      body: StreamBuilder(
        stream: stream,
        builder: (_, snapshot) {
          final entries = snapshot.data ?? [];
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (_, i) {
              final e = entries[i];
              return ListTile(
                title: Text(e.dateId),
                subtitle: Text('Mood ${e.mood} • ${e.activities.join(', ')} ${e.note}'),
              );
            },
          );
        },
      ),
    );
  }
}
