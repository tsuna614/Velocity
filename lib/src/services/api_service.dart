import 'package:dio/dio.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<ApiResponse<T>> fetchData<T>({
    required String endpoint,
    required T Function(dynamic data) fromJson,
  }) async {
    try {
      final response = await dio.get(endpoint);

      return ApiResponse(data: fromJson(response.data));
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }

  // Future<ApiResponse<T>> postData<T>({
  //   required String endpoint,
  //   required dynamic data,
  //   required T Function(dynamic data) fromJson,
  // }) async {
  //   try {
  //     final response = await dio.post(
  //       endpoint,
  //       data: data,
  //     );

  //     return ApiResponse(data: fromJson(response.data));
  //   } on DioException catch (e) {
  //     return ApiResponse(errorMessage: e.message);
  //   }
  // }

  Future<ApiResponse<T>> postData<T>({
    required String endpoint,
    required dynamic data,
    required T Function(dynamic data) fromJson,
  }) async {
    try {
      final response = await dio.post(endpoint, data: data);
      return ApiResponse(data: fromJson(response.data));
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }
}

class ApiResponse<T> {
  final T? data;
  final String? errorMessage;

  ApiResponse({
    this.data,
    this.errorMessage,
  });
}
