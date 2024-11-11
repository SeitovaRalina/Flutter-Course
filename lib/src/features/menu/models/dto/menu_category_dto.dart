class MenuCategoryDto {
  final int id;
  final String slug;

  MenuCategoryDto({required this.id, required this.slug});

  factory MenuCategoryDto.fromJson(Map<String, dynamic> json) {
    return MenuCategoryDto(
      id: json['id'] as int,
      slug: json['slug'] as String,
    );
  }
}
