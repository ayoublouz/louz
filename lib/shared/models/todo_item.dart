class TodoItem {
  final String id;
  final String title;
  final bool done;

  TodoItem({required this.id, required this.title, required this.done});

  factory TodoItem.fromMap(String id, Map<String, dynamic> map) => TodoItem(
        id: id,
        title: map['title'] ?? '',
        done: map['done'] ?? false,
      );

  Map<String, dynamic> toMap() => {'title': title, 'done': done};
}
