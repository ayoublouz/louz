class InterestItem {
  final String id;
  final String category;
  final String title;
  final String note;

  InterestItem({
    required this.id,
    required this.category,
    required this.title,
    required this.note,
  });

  factory InterestItem.fromMap(String id, Map<String, dynamic> map) => InterestItem(
        id: id,
        category: map['category'] ?? '',
        title: map['title'] ?? '',
        note: map['note'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'category': category,
        'title': title,
        'note': note,
      };
}
