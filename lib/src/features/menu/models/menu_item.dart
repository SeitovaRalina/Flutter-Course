import 'package:flutter_course/src/features/menu/models/menu_category.dart';

class MenuItem {
  final int id;
  final String name;
  final int price;
  final String? imageUrl;
  final MenuCategory category;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    required this.category,
  });
}
