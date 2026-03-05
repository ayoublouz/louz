import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/services/repository_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _bio = TextEditingController();
  final _quote = TextEditingController();
  final _summary = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text('No user')));

    final stream = ref.watch(profileRepositoryProvider).watchProfile(user.uid);

    return Scaffold(
      appBar: AppBar(title: const Text('Private profile')),
      body: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data != null) {
            _bio.text = data.bio;
            _quote.text = data.quote;
            _summary.text = data.interestsSummary;
          }
          return ListView(padding: const EdgeInsets.all(20), children: [
            Text('Username: ${data?.username ?? '-'}'),
            const SizedBox(height: 12),
            TextField(controller: _bio, decoration: const InputDecoration(labelText: 'Bio')),
            const SizedBox(height: 12),
            TextField(controller: _quote, decoration: const InputDecoration(labelText: 'Quote')),
            const SizedBox(height: 12),
            TextField(controller: _summary, decoration: const InputDecoration(labelText: 'Interests summary')),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                await ref.read(profileRepositoryProvider).upsertProfile(
                      uid: user.uid,
                      email: user.email ?? '',
                      username: data?.username ?? '',
                      bio: _bio.text.trim(),
                      quote: _quote.text.trim(),
                      interestsSummary: _summary.text.trim(),
                      themeId: data?.themeId ?? 'calm-default',
                    );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
                }
              },
              child: const Text('Save profile'),
            )
          ]);
        },
      ),
    );
  }
}
