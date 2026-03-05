import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/checkin_entry.dart';
import '../../../shared/services/repository_providers.dart';
import '../data/checkin_repository.dart';

class CheckinScreen extends ConsumerStatefulWidget {
  const CheckinScreen({super.key});

  @override
  ConsumerState<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends ConsumerState<CheckinScreen> {
  int mood = 3;
  final note = TextEditingController();
  final activities = <String>{};
  static const chips = ['Reading', 'Workout', 'Work', 'Family', 'Walk', 'Music'];

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Scaffold(body: Center(child: Text('No user')));

    return Scaffold(
      appBar: AppBar(title: const Text('Daily check-in')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Mood (1-5)'),
          Slider(value: mood.toDouble(), min: 1, max: 5, divisions: 4, label: '$mood', onChanged: (v) => setState(() => mood = v.round())),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: chips
                .map((e) => FilterChip(
                      label: Text(e),
                      selected: activities.contains(e),
                      onSelected: (s) => setState(() => s ? activities.add(e) : activities.remove(e)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          TextField(controller: note, maxLines: 4, decoration: const InputDecoration(labelText: 'Optional note')),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              await ref.read(checkinRepositoryProvider).saveToday(
                    uid,
                    CheckinEntry(
                      dateId: CheckinRepository.todayId(),
                      mood: mood,
                      activities: activities.toList(),
                      note: note.text.trim(),
                    ),
                  );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You're done for today")));
              }
            },
            child: const Text('Save check-in'),
          )
        ],
      ),
    );
  }
}
