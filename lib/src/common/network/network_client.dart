// ignore_for_file: inference_failure_on_function_invocation

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_course/src/common/network/response_handler.dart';

abstract interface class INetworkClient {
  Future<List<dynamic>> getAllCategories();
  Future<List<dynamic>> getAllProducts(int count);
  Future<List<dynamic>> getAllProductsByCategory(
    int categoryId,
    int limit,
    int page,
  );
  Future<Map<String, dynamic>> getProductByID(int id);
  Future<bool> postOrder(Map<String, int> orderData);
}

final class CoffeeShopNetworkClient implements INetworkClient {
  final String _menuVersion = '/api/v1/products';
  final String _orderVersion = '/api/v1/orders';
  final Dio _dio;

  CoffeeShopNetworkClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://coffeeshop.academy.effective.band',
            headers: {'Content-Type': 'application/json'},
          ),
        );

  @override
  Future<List<dynamic>> getAllCategories() async {
    final url = '$_menuVersion/categories';

    try {
      final response = await _dio.get(url);
      return ResponseHandler.handleListResponse(response);
    } on DioException catch (e) {
      throw Exception('Failed to fetch categories: ${e.message}');
    }
  }

  @override
  Future<List<dynamic>> getAllProducts(int count) async {
    final url = _menuVersion;
    final params = {
      'page': '0',
      'limit': '$count',
    };

    try {
      final response = await _dio.get(url, queryParameters: params);
      return ResponseHandler.handleListResponse(response);
    } on DioException catch (e) {
      throw Exception('Failed to fetch products: ${e.message}');
    }
  }

  @override
  Future<List<dynamic>> getAllProductsByCategory(
    int categoryId,
    int limit,
    int page,
  ) async {
    final url = _menuVersion;
    final params = {
      'page': '$page',
      'limit': '$limit',
      'category': '$categoryId',
    };

    try {
      final response = await _dio.get(url, queryParameters: params);
      return ResponseHandler.handleListResponse(response);
    } on DioException catch (e) {
      throw Exception('Failed to fetch products by category: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getProductByID(int id) async {
    final url = '$_menuVersion/$id';

    try {
      final response = await _dio.get(url);
      return ResponseHandler.handleMapResponse(response);
    } on DioException catch (e) {
      throw Exception('Failed to fetch product by ID: ${e.message}');
    }
  }

  @override
  Future<bool> postOrder(Map<String, int> orderData) async {
    final url = _orderVersion;
    final requestBody = {
      'positions': orderData,
      'token': '',
    };

    try {
      final response = await _dio.post(url, data: jsonEncode(requestBody));
      if (response.statusCode == 201) return true;
      if (response.statusCode == 422) throw Exception('Validation Error');
      return false;
    } on DioException catch (e) {
      throw Exception('Failed to post order: ${e.message}');
    }
  }
}
