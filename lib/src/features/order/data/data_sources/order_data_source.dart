import 'package:dio/dio.dart';
import 'package:flutter_course/src/features/menu/models/menu_item.dart';

abstract interface class IOrderDataSource {
  Future<Map<String, dynamic>> postOrder({
    required Map<MenuItem, int> items,
  });
}

final class NetworkOrderDataSource implements IOrderDataSource {
  final Dio _dio;

  const NetworkOrderDataSource(Dio dio) : _dio = dio;

  @override
  Future<Map<String, dynamic>> postOrder({
    required Map<MenuItem, dynamic> items,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/orders',
      data: {
        'positions': items.map((k, v) => MapEntry('${k.id}', v)),
        'token': '',
      },
    );
    return response.data!;
  }
}
