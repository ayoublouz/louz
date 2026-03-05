import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/services/repository_providers.dart';

class GalleryScreen extends ConsumerWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Scaffold(body: Center(child: Text('No user')));
    final stream = ref.watch(galleryRepositoryProvider).watch(uid);

    return Scaffold(
      appBar: AppBar(title: const Text('Private gallery')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
          if (image == null) return;
          if (context.mounted) {
            final captionCtrl = TextEditingController();
            await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Caption'),
                content: TextField(controller: captionCtrl),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  FilledButton(
                    onPressed: () async {
                      await ref.read(galleryRepositoryProvider).upload(
                            uid: uid,
                            file: File(image.path),
                            caption: captionCtrl.text.trim(),
                          );
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  )
                ],
              ),
            );
          }
        },
        child: const Icon(Icons.add_a_photo_outlined),
      ),
      body: StreamBuilder(
        stream: stream,
        builder: (_, snapshot) {
          final items = snapshot.data ?? [];
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) => ListTile(
              leading: Image.network(items[i].imageUrl, width: 52, height: 52, fit: BoxFit.cover),
              title: Text(items[i].caption),
              subtitle: Text(items[i].createdAt),
            ),
          );
        },
      ),
    );
  }
}
