class AppUser {
  final String uid;
  final String email;
  final String username;
  final String bio;
  final String quote;
  final String interestsSummary;
  final String themeId;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.username,
    required this.bio,
    required this.quote,
    required this.interestsSummary,
    required this.themeId,
    required this.createdAt,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
        uid: map['uid'] ?? '',
        email: map['email'] ?? '',
        username: map['username'] ?? '',
        bio: map['bio'] ?? '',
        quote: map['quote'] ?? '',
        interestsSummary: map['interestsSummary'] ?? '',
        themeId: map['themeId'] ?? 'calm-default',
        createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'username': username,
        'bio': bio,
        'quote': quote,
        'interestsSummary': interestsSummary,
        'themeId': themeId,
        'createdAt': createdAt.toIso8601String(),
      };
}
