class GalleryItem {
  final String id;
  final String imageUrl;
  final String caption;
  final String createdAt;

  GalleryItem({
    required this.id,
    required this.imageUrl,
    required this.caption,
    required this.createdAt,
  });

  factory GalleryItem.fromMap(String id, Map<String, dynamic> map) => GalleryItem(
        id: id,
        imageUrl: map['imageUrl'] ?? '',
        caption: map['caption'] ?? '',
        createdAt: map['createdAt'] ?? '',
      );
}
