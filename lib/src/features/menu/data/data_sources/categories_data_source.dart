import 'package:flutter_course/src/common/network/network_client.dart';
import 'package:flutter_course/src/features/menu/models/dto/menu_category_dto.dart';

abstract interface class ICategoriesDataSource {
  Future<List<MenuCategoryDto>> fetchCategories();
}

final class NetworkCategoriesDataSource implements ICategoriesDataSource {
  final INetworkClient _client;

  const NetworkCategoriesDataSource(INetworkClient client): _client = client;

  @override
  Future<List<MenuCategoryDto>> fetchCategories() async {
    final response = await _client.getAllCategories();
    return response.map((item) => MenuCategoryDto.fromJson(item as Map<String, dynamic>)).toList();
  }
}
