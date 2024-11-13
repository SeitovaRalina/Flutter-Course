import 'package:dio/dio.dart';
import 'package:flutter_course/src/features/menu/models/dto/menu_category_dto.dart';

abstract interface class ICategoriesDataSource {
  Future<List<MenuCategoryDto>> fetchCategories();
}

final class NetworkCategoriesDataSource implements ICategoriesDataSource {
  final Dio _dio;

  const NetworkCategoriesDataSource(Dio dio) : _dio = dio;

  @override
   Future<List<MenuCategoryDto>> fetchCategories() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/products/categories');

      if (response.statusCode == 200) {
        final data = response.data!['data'] as List<dynamic>;

        return data
            .map((item) => MenuCategoryDto.fromJson(item as Map<String, dynamic>))
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
