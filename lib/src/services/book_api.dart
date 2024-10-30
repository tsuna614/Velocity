import 'package:dio/dio.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/book_model.dart';
import 'package:velocity_app/src/services/api_response.dart';

abstract class BookApi {
  Future<ApiResponse<List<Book>>> fetchBookData();
  Future<ApiResponse<Book>> createBook({required Book book});
}

class BookApiImpl extends BookApi {
  final baseUrl = GlobalData.baseUrl;
  Dio dio = Dio();

  @override
  Future<ApiResponse<List<Book>>> fetchBookData() async {
    try {
      final response = await dio
          .get('$baseUrl/book/getAllBooksByUserId/${GlobalData.userId}');

      List<Book> books = [];

      response.data.forEach((book) {
        books.add(Book.fromJson(book));
      });

      return ApiResponse(data: books);
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }

  @override
  Future<ApiResponse<Book>> createBook({required Book book}) async {
    try {
      final response = await dio.post(
        '$baseUrl/book/createBook',
        data: {
          "userId": GlobalData.userId,
          "travelId": book.travelId,
          "bookedDate": book.dateOfTravel.toString(),
          "amount": book.amount,
        },
      );

      return ApiResponse(data: Book.fromJson(response.data));
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }
}
