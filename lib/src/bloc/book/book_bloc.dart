import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/book/book.events.dart';
import 'package:velocity_app/src/bloc/book/book.states.dart';
import 'package:velocity_app/src/model/book_model.dart';
import 'package:velocity_app/src/services/api_response.dart';
import 'package:velocity_app/src/services/book_api.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookApi bookApi;

  BookBloc(this.bookApi) : super(BookInitial()) {
    on<FetchBooks>((event, emit) async {
      emit(BookLoading());
      final ApiResponse<List<Book>> response = await bookApi.fetchBookData();
      // If there is an error message, emit BookFailure, otherwise emit BookLoaded
      if (response.errorMessage != null) {
        emit(BookFailure(message: response.errorMessage!));
      } else {
        emit(BookLoaded(books: response.data!));
      }
    });

    on<AddBook>((event, emit) async {
      if (state is BookLoaded) {
        final response = await bookApi.createBook(book: event.book);
        if (response.errorMessage == null) {
          List<Book> updatedBooks = [
            response.data!,
            ...(state as BookLoaded).books
          ];
          emit(BookLoaded(books: updatedBooks));
        } else {
          emit(BookFailure(message: response.errorMessage!));
        }
      }
    });
  }
}
