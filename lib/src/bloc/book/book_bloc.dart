import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/book/book.events.dart';
import 'package:velocity_app/src/bloc/book/book.states.dart';
import 'package:velocity_app/src/model/book_model.dart';
import 'package:velocity_app/src/services/book_api.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookApi bookApi;

  BookBloc(this.bookApi) : super(BookInitial()) {
    on<FetchBooks>((event, emit) async {
      emit(BookLoading());
      final List<Book> books = await bookApi.fetchBookData();
      emit(BookLoaded(books: books));
    });

    on<AddBook>((event, emit) async {
      if (state is BookLoaded) {
        Book createdBook = await bookApi.createBook(book: event.book);
        List<Book> updatedBooks = [createdBook, ...(state as BookLoaded).books];
        emit(BookLoaded(books: updatedBooks));
      }
    });
  }
}
