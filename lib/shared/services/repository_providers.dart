import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/checkin/data/checkin_repository.dart';
import '../../features/friends/data/friends_repository.dart';
import '../../features/gallery/data/gallery_repository.dart';
import '../../features/interests/data/interests_repository.dart';
import '../../features/profile/data/profile_repository.dart';
import '../../features/todo/data/todo_repository.dart';
import 'firebase_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(firebaseAuthProvider), ref.watch(firestoreProvider)),
);
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(firestoreProvider)),
);
final interestsRepositoryProvider = Provider<InterestsRepository>(
  (ref) => InterestsRepository(ref.watch(firestoreProvider)),
);
final checkinRepositoryProvider = Provider<CheckinRepository>(
  (ref) => CheckinRepository(ref.watch(firestoreProvider)),
);
final friendsRepositoryProvider = Provider<FriendsRepository>(
  (ref) => FriendsRepository(ref.watch(firestoreProvider)),
);
final galleryRepositoryProvider = Provider<GalleryRepository>(
  (ref) => GalleryRepository(ref.watch(firestoreProvider), ref.watch(storageProvider)),
);
final todoRepositoryProvider = Provider<TodoRepository>(
  (ref) => TodoRepository(ref.watch(firestoreProvider)),
);
