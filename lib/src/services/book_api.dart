import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/book_model.dart';
import 'package:velocity_app/src/services/api_service.dart';

abstract class BookApi {
  final ApiService apiService;
  BookApi(this.apiService);

  Future<ApiResponse<List<BookModel>>> fetchBookData();
  Future<ApiResponse<BookModel>> createBook({required BookModel book});
}

class BookApiImpl extends BookApi {
  final baseUrl = GlobalData.baseUrl;

  BookApiImpl(super.apiService);

  @override
  Future<ApiResponse<List<BookModel>>> fetchBookData() async {
    // call to the get method of api service to fetch all books
    // we do this to minimize the code needed for duplicating try-catch blocks
    return apiService.get(
      endpoint: '$baseUrl/book/getAllBooksByUserId/${GlobalData.userId}',
      fromJson: (data) =>
          data.map<BookModel>((book) => BookModel.fromJson(book)).toList(),
    );
  }

  @override
  Future<ApiResponse<BookModel>> createBook({required BookModel book}) async {
    // call to the post method of ApiService to create a book
    return apiService.post(
      endpoint: '$baseUrl/book/createBook',
      data: {
        "userId": GlobalData.userId,
        "travelId": book.travelId,
        "bookedDate": book.dateOfTravel.toString(),
        "amount": book.amount,
      },
      fromJson: (data) => BookModel.fromJson(data),
    );
  }
}
