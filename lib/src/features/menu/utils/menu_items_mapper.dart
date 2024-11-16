import 'package:flutter_course/src/features/menu/models/dto/menu_category_dto.dart';
import 'package:flutter_course/src/features/menu/models/dto/menu_item_dto.dart';
import 'package:flutter_course/src/features/menu/models/menu_item.dart';
import 'package:flutter_course/src/features/menu/utils/category_mapper.dart';

extension MenuItemsMapper on MenuItemDto {
  MenuItem toModel() {
    final rubPrice =
        prices.firstWhere((price) => price['currency'] == 'RUB')['value'];
    return MenuItem(
      id: id,
      name: name,
      category: MenuCategoryDto.fromJson(category).toModel(),
      imageUrl: imageUrl,
      price: double.parse(rubPrice as String).round(),
    );
  }
}
