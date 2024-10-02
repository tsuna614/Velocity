import 'package:velocity_app/src/model/book_model.dart';

abstract class BookEvent {}

class FetchBooks extends BookEvent {}

class AddBook extends BookEvent {
  final Book book;

  AddBook(this.book);
}
