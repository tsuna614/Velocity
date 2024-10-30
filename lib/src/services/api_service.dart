import 'package:dio/dio.dart';

enum HttpMethod { get, post, put, delete }

class ApiService {
  final HttpMethod method;
  final String path;
  final Map<String, dynamic>? body;

  ApiService({
    required this.method,
    required this.path,
    this.body,
  });

  final dio = Dio();

  Future<Response> call() async {
    switch (method) {
      case HttpMethod.get:
        return await dio.get(path);
      case HttpMethod.post:
        return await dio.post(path, data: body);
      case HttpMethod.put:
        return await dio.put(path, data: body);
      case HttpMethod.delete:
        return await dio.delete(path);
    }
  }
}
