import 'package:velocity_app/src/model/book_model.dart';

abstract class BookState {}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  List<Book> books;

  BookLoaded({required this.books});
}
