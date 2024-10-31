import 'package:dio/dio.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<ApiResponse<T>> get<T>({
    // this is the url for the http method call
    required String endpoint,
    // this is to convert the response, if we want it to convert to the type we desire
    // we pass the convert function to wherever we need to make the call
    // for example, for Map<String, dynamic> -> Book, we use:
    // "fromJson: (data) => Book.fromJson(data)" to fetch a single book
    // "fromJson: (data) => data.map<Book>((book) => Book.fromJson(book)).toList()" to fetch a list of book
    required T Function(dynamic data)? fromJson,
  }) async {
    try {
      final response = await dio.get(endpoint);
      return ApiResponse(
        data: fromJson != null ? fromJson(response.data) : response.data,
      );
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }

  Future<ApiResponse<T>> post<T>({
    required String endpoint,
    // this is the body that you put into the http method call. GET method don't have the body so this field is not needed
    required dynamic data,
    required T Function(dynamic data)? fromJson,
  }) async {
    try {
      final response = await dio.post(endpoint, data: data);
      return ApiResponse(
        data: fromJson != null ? fromJson(response.data) : response.data,
      );
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }

  Future<ApiResponse<T>> put<T>({
    required String endpoint,
    required dynamic data,
    T Function(dynamic data)? fromJson,
  }) async {
    try {
      final response = await dio.put(endpoint, data: data);
      return ApiResponse(
        data: fromJson != null ? fromJson(response.data) : response.data,
      );
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }

  Future<ApiResponse<T>> delete<T>({
    required String endpoint,
    required T Function(dynamic data) fromJson,
  }) async {
    try {
      final response = await dio.delete(endpoint);
      return ApiResponse(data: response.data);
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
