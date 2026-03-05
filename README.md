# Temporary Name (Calm Private Identity App) - MVP

## A) Development Phases Plan
1. **Foundation**: Configure FlutterFire, auth flow, router, theme, base repositories.
2. **Core Identity**: Onboarding, username uniqueness mapping, private profile.
3. **Personal Data Features**: Interests CRUD, daily check-ins + history, private to-do.
4. **Private Social**: Friend requests by username, accept/bi-directional friendship, circles.
5. **Memories**: Private gallery upload to Storage + Firestore metadata.
6. **Hardening**: Security rules, indexes, UI polish, empty/error states, QA.

## B) Firestore Data Model
- `usernames/{username}`
  - `uid: string`
  - `createdAt: timestamp`
- `users/{uid}`
  - `uid, email, username, bio, quote, interestsSummary, themeId`
  - `createdAt, updatedAt`
- `users/{uid}/interests/{interestId}`
  - `category` (movies/books/music/games/sports/celebrities/travel)
  - `title, note, createdAt`
- `users/{uid}/checkins/{YYYY-MM-DD}`
  - `mood: 1..5`
  - `activities: string[]`
  - `note, updatedAt`
- `friendRequests/{requestId}`
  - `fromUid, fromUsername, toUid, status: pending|accepted, createdAt`
- `users/{uid}/friends/{friendUid}`
  - `uid, circle: close_friends|family, createdAt, updatedAt`
- `users/{uid}/gallery/{itemId}`
  - `imageUrl, caption, createdAt`
- `users/{uid}/todos/{todoId}`
  - `title, done`

## D) Flutter Folder Structure
```text
lib/
  core/
    router/
    theme/
  features/
    auth/
    onboarding/
    dashboard/
    profile/
    interests/
    checkin/
    friends/
    gallery/
    todo/
  shared/
    models/
    services/
```

## G) Setup Instructions
1. Install dependencies:
   ```bash
   flutter pub get
   ```
2. Configure Firebase:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
3. Replace placeholder `lib/firebase_options.dart` with generated file from FlutterFire.
4. Android: place `google-services.json` in `android/app/`.
5. iOS: place `GoogleService-Info.plist` in `ios/Runner/` and add in Xcode Runner target.
6. Deploy rules:
   ```bash
   firebase deploy --only firestore:rules,storage
   ```
7. Run app:
   ```bash
   flutter run
   ```
