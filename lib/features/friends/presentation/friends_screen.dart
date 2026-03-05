import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/services/repository_providers.dart';

class FriendsScreen extends ConsumerWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = FirebaseAuth.instance.currentUser;
    if (me == null) return const Scaffold(body: Center(child: Text('No user')));
    final usernameCtrl = TextEditingController();
    final profileStream = ref.watch(profileRepositoryProvider).watchProfile(me.uid);

    return Scaffold(
      appBar: AppBar(title: const Text('Friends & circles')),
      body: StreamBuilder(
        stream: profileStream,
        builder: (context, profileSnapshot) {
          final username = profileSnapshot.data?.username ?? '';
          final reqStream = ref.watch(friendsRepositoryProvider).incomingRequests(me.uid);
          final friendsStream = ref.watch(friendsRepositoryProvider).friends(me.uid);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(controller: usernameCtrl, decoration: const InputDecoration(labelText: 'Add friend by username')),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () async {
                  final targetUid = await ref.read(friendsRepositoryProvider).uidByUsername(usernameCtrl.text.trim());
                  if (targetUid != null) {
                    await ref.read(friendsRepositoryProvider).sendRequest(
                          fromUid: me.uid,
                          fromUsername: username,
                          toUid: targetUid,
                        );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request sent')));
                    }
                  }
                },
                child: const Text('Send request'),
              ),
              const Divider(height: 32),
              const Text('Incoming requests'),
              StreamBuilder(
                stream: reqStream,
                builder: (context, snapshot) {
                  final requests = snapshot.data ?? [];
                  return Column(
                    children: requests
                        .map((r) => ListTile(
                              title: Text('@${r.fromUsername}'),
                              trailing: TextButton(
                                onPressed: () => ref.read(friendsRepositoryProvider).acceptRequest(r),
                                child: const Text('Accept'),
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
              const Divider(height: 32),
              const Text('Friends'),
              StreamBuilder(
                stream: friendsStream,
                builder: (_, snapshot) {
                  final friends = snapshot.data ?? [];
                  return Column(
                    children: friends
                        .map((f) => ListTile(
                              title: Text(f['id']),
                              subtitle: Text('Circle: ${f['circle'] ?? 'close_friends'}'),
                              trailing: DropdownButton<String>(
                                value: (f['circle'] ?? 'close_friends') as String,
                                items: const [
                                  DropdownMenuItem(value: 'close_friends', child: Text('Close Friends')),
                                  DropdownMenuItem(value: 'family', child: Text('Family')),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    ref.read(friendsRepositoryProvider).assignCircle(
                                          uid: me.uid,
                                          friendUid: f['id'] as String,
                                          circle: v,
                                        );
                                  }
                                },
                              ),
                            ))
                        .toList(),
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
