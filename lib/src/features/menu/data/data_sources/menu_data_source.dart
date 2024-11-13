import 'package:dio/dio.dart';
import 'package:flutter_course/src/features/menu/models/dto/menu_item_dto.dart';

abstract interface class IMenuDataSource {
  Future<List<MenuItemDto>> fetchMenuItems({
    required int categoryId,
    int page = 0,
    int limit = 25,
  });
}

final class NetworkMenuDataSource implements IMenuDataSource {
  final Dio _dio;

  const NetworkMenuDataSource(Dio dio) : _dio = dio;

  @override
  Future<List<MenuItemDto>> fetchMenuItems({
    required int categoryId,
    int page = 0,
    int limit = 25,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/products',
        queryParameters: {
          'category': '$categoryId',
          'page': '$page',
          'limit': '$limit',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data!['data'] as List<dynamic>;

        return data
            .map((item) => MenuItemDto.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('An unexpected response status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch categories: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }
}
