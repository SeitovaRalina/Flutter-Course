import 'package:flutter_course/src/common/network/network_client.dart';
import 'package:flutter_course/src/features/menu/models/dto/menu_item_dto.dart';

abstract interface class IMenuDataSource {
  Future<List<MenuItemDto>> fetchMenuItems({
    required int categoryId,
    int page = 0,
    int limit = 25,
  });
}

final class NetworkMenuDataSource implements IMenuDataSource {
  final INetworkClient _client;

  const NetworkMenuDataSource(this._client);

  @override
  Future<List<MenuItemDto>> fetchMenuItems({
    required int categoryId,
    int page = 0,
    int limit = 25,
  }) async {
    final response = await _client.getAllProductsByCategory(categoryId, limit, page);
    return response.map((item) => MenuItemDto.fromJson(item as Map<String, dynamic>)).toList();
  }
}
