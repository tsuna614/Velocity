import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/book_model.dart';
import 'package:velocity_app/src/services/api_service.dart';

abstract class BookApi {
  final ApiService apiService;

  BookApi(this.apiService);

  Future<ApiResponse<List<Book>>> fetchBookData();
  Future<ApiResponse> createBook({required Book book});
}

class BookApiImpl extends BookApi {
  final baseUrl = GlobalData.baseUrl;

  BookApiImpl(super.apiService);

  @override
  Future<ApiResponse<List<Book>>> fetchBookData() async {
    // try {
    //   final response = await dio
    //       .get('$baseUrl/book/getAllBooksByUserId/${GlobalData.userId}');

    //   List<Book> books = [];

    //   response.data.forEach((book) {
    //     books.add(Book.fromJson(book));
    //   });

    //   return ApiResponse(data: books);
    // } on DioException catch (e) {
    //   return ApiResponse(errorMessage: e.message);
    // }

    return apiService.fetchData(
      endpoint: '$baseUrl/book/getAllBooksByUserId/${GlobalData.userId}',
      fromJson: (data) =>
          data.map<Book>((book) => Book.fromJson(book)).toList(),
    );
  }

  @override
  Future<ApiResponse<Book>> createBook({required Book book}) async {
    return apiService.postData(
      endpoint: '$baseUrl/book/createBook',
      data: {
        "userId": GlobalData.userId,
        "travelId": book.travelId,
        "bookedDate": book.dateOfTravel.toString(),
        "amount": book.amount,
      },
      fromJson: (data) => Book.fromJson(data),
    );
  }
}
