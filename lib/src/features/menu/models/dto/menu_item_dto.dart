class MenuItemDto {
  final int id;
  final String name;
  final String description;
  final Map<String, dynamic> category;
  final String imageUrl;
  final List<Map<String, dynamic>> prices;

  MenuItemDto({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.prices,
  });

  factory MenuItemDto.fromJson(Map<String, dynamic> json) {
    return MenuItemDto(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as Map<String, dynamic>,
      imageUrl: json['imageUrl'] as String,
      prices: List<Map<String, dynamic>>.from(json['prices'] as Iterable<dynamic>),
    );
  }
}
