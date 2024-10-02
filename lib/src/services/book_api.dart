import 'package:dio/dio.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/book_model.dart';

class BookApi {
  final baseUrl = GlobalData.baseUrl;
  Dio dio = Dio();

  Future<List<Book>> fetchBookData() async {
    try {
      final response = await dio
          .get('$baseUrl/book/getAllBooksByUserId/${GlobalData.userId}');

      List<Book> books = [];

      response.data.forEach((book) {
        books.add(Book.fromJson(book));
      });

      return books;
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message,
      );
    }
  }

  Future<Book> createBook({required Book book}) async {
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

      return Book.fromJson(response.data);
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message,
      );
    }
  }
}
