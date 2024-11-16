import 'package:flutter_course/src/features/menu/data/data_sources/categories_data_source.dart';
import 'package:flutter_course/src/features/menu/models/dto/menu_category_dto.dart';
import 'package:flutter_course/src/features/menu/models/menu_category.dart';
import 'package:flutter_course/src/features/menu/utils/category_mapper.dart';

abstract interface class ICategoryRepository {
  Future<List<MenuCategory>> loadCategories();
}

final class CategoriesRepository implements ICategoryRepository {
  final ICategoriesDataSource _networkCategoriesDataSource;

  const CategoriesRepository({
    required ICategoriesDataSource networkCategoriesDataSource,
  }) : _networkCategoriesDataSource = networkCategoriesDataSource;

  @override
  Future<List<MenuCategory>> loadCategories() async {
    var dtos = <MenuCategoryDto>[];
    dtos = await _networkCategoriesDataSource.fetchCategories();
    return dtos.map((e) => e.toModel()).toList();
  }
}
