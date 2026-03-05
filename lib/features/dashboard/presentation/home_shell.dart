import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/services/repository_providers.dart';

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Scaffold(body: Center(child: Text('No session')));

    final today = ref.watch(checkinRepositoryProvider).watchToday(uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calm dashboard'),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: StreamBuilder(
        stream: today,
        builder: (context, snapshot) {
          final done = snapshot.data != null;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(done ? "You're done for today ✨" : 'Take 2 minutes for your check-in.'),
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _NavCard(title: 'Daily Check-in', route: '/checkin'),
                  _NavCard(title: 'Check-in History', route: '/checkin-history'),
                  _NavCard(title: 'Profile', route: '/profile'),
                  _NavCard(title: 'Interests', route: '/interests'),
                  _NavCard(title: 'Friends', route: '/friends'),
                  _NavCard(title: 'Gallery', route: '/gallery'),
                  _NavCard(title: 'To-do', route: '/todos'),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  const _NavCard({required this.title, required this.route});
  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: OutlinedButton(
        onPressed: () => context.push(route),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(title, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
