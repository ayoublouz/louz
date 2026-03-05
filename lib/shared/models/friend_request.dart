class FriendRequest {
  final String id;
  final String fromUid;
  final String fromUsername;
  final String toUid;
  final String status;

  FriendRequest({
    required this.id,
    required this.fromUid,
    required this.fromUsername,
    required this.toUid,
    required this.status,
  });

  factory FriendRequest.fromMap(String id, Map<String, dynamic> map) => FriendRequest(
        id: id,
        fromUid: map['fromUid'] ?? '',
        fromUsername: map['fromUsername'] ?? '',
        toUid: map['toUid'] ?? '',
        status: map['status'] ?? 'pending',
      );
}
