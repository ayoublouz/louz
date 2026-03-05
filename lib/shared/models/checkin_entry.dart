class CheckinEntry {
  final String dateId;
  final int mood;
  final List<String> activities;
  final String note;

  CheckinEntry({
    required this.dateId,
    required this.mood,
    required this.activities,
    required this.note,
  });

  factory CheckinEntry.fromMap(String id, Map<String, dynamic> map) => CheckinEntry(
        dateId: id,
        mood: map['mood'] ?? 3,
        activities: List<String>.from(map['activities'] ?? []),
        note: map['note'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'mood': mood,
        'activities': activities,
        'note': note,
      };
}
