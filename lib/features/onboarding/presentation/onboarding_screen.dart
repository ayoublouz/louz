import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/services/repository_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _username = TextEditingController();
  final _bio = TextEditingController();
  final _quote = TextEditingController();
  final _summary = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text('Please login')));

    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Make your calm private profile'),
          const SizedBox(height: 16),
          TextField(controller: _username, decoration: const InputDecoration(labelText: 'Unique username')),
          const SizedBox(height: 12),
          TextField(controller: _bio, decoration: const InputDecoration(labelText: 'Bio')),
          const SizedBox(height: 12),
          TextField(controller: _quote, decoration: const InputDecoration(labelText: 'Quote')),
          const SizedBox(height: 12),
          TextField(controller: _summary, decoration: const InputDecoration(labelText: 'Interests summary')),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () async {
              final authRepo = ref.read(authRepositoryProvider);
              final profileRepo = ref.read(profileRepositoryProvider);
              await authRepo.saveUsername(uid: user.uid, username: _username.text.trim());
              await profileRepo.upsertProfile(
                uid: user.uid,
                email: user.email ?? '',
                username: _username.text.trim().toLowerCase(),
                bio: _bio.text.trim(),
                quote: _quote.text.trim(),
                interestsSummary: _summary.text.trim(),
                themeId: 'calm-default',
              );
              if (context.mounted) context.go('/');
            },
            child: const Text('Finish onboarding'),
          ),
        ],
      ),
    );
  }
}
