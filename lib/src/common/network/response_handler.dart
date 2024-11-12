import 'package:dio/dio.dart';

class ResponseHandler {
  static List<dynamic> handleListResponse(Response<dynamic> response) {
    if (response.statusCode == 200) {
      try {
        return (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
      } catch (e) {
        throw Exception('Failed to parse response as List: $e');
      }
    } else {
      throw Exception('Unexpected response status: ${response.statusCode}');
    }
  }

  static Map<String, dynamic> handleMapResponse(Response<dynamic> response) {
    if (response.statusCode == 200) {
      try {
        return response.data as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Failed to parse response as Map: $e');
      }
    } else {
      throw Exception('Unexpected response status: ${response.statusCode}');
    }
  }
}
