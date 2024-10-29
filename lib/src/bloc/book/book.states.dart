import 'package:velocity_app/src/model/book_model.dart';

abstract class BookState {}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookFailure extends BookState {
  String message;

  BookFailure({required this.message});
}

class BookLoaded extends BookState {
  List<Book> books;

  BookLoaded({required this.books});
}
