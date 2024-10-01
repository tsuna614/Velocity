import 'package:dio/dio.dart';
import 'package:velocity_app/src/data/global_data.dart';

abstract class BookApi {
  static final baseUrl = GlobalData.baseUrl;
  static final dio = Dio();

  // static Future<List<Book>> fetchBookData() async {
  //   try {
  //     final response = await dio.get('$baseUrl/book/getAllBooks');

  //     List<Book> books = [];

  //     response.data.forEach((book) {
  //       switch (book['bookType']) {
  //         case "fiction":
  //           books.add(Fiction.fromJson(book));
  //           break;
  //         case "nonFiction":
  //           books.add(NonFiction.fromJson(book));
  //           break;
  //         case "biography":
  //           books.add(Biography.fromJson(book));
  //           break;
  //         case "selfHelp":
  //           books.add(SelfHelp.fromJson(book));
  //           break;
  //         default:
  //       }
  //     });

  //     return books;
  //   } on DioException catch (e) {
  //     throw DioException(
  //       requestOptions: e.requestOptions,
  //       response: e.response,
  //       message: e.message,
  //     );
  //   }
  // }

  // static Future<void> createBook()
}
