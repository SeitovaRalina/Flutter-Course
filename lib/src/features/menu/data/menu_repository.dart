import 'package:flutter_course/src/features/menu/data/data_sources/menu_data_source.dart';
import 'package:flutter_course/src/features/menu/models/dto/menu_item_dto.dart';
import 'package:flutter_course/src/features/menu/models/menu_category.dart';
import 'package:flutter_course/src/features/menu/models/menu_item.dart';
import 'package:flutter_course/src/features/menu/utils/menu_items_mapper.dart';

abstract interface class IMenuRepository {
  Future<List<MenuItem>> loadMenuItems({
    required MenuCategory category,
    int page = 0,
    int limit = 25,
  });
}

final class MenuRepository implements IMenuRepository {
  final IMenuDataSource _networkMenuDataSource;

  const MenuRepository({
    required IMenuDataSource networkMenuDataSource,
  }) : _networkMenuDataSource = networkMenuDataSource;

  @override
  Future<List<MenuItem>> loadMenuItems({
    required MenuCategory category,
    int page = 0,
    int limit = 25,
  }) async {
    var dtos = <MenuItemDto>[];
    dtos = await _networkMenuDataSource.fetchMenuItems(
      categoryId: category.id,
      page: page,
      limit: limit,
    );
    return dtos.map((e) => e.toModel()).toList();
  }
}
