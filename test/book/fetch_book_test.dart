import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:velocity_app/src/model/book_model.dart';

import 'fetch_book_test.mocks.dart';

void main() {
  late MockBookApi mockBookApi;

  setUp(() {
    mockBookApi = MockBookApi();
  });

  group('BookApi Test', () {
    test('Fetch books returns a list of books', () async {
      // Arrange
      List<Book> mockBooks = [
        // Book(
        //   id: id,
        //   travelId: travelId,
        //   userId: userId,
        //   dateOfTravel: dateOfTravel,
        //   dateOfBooking: dateOfBooking,
        //   amount: amount,
        // ),
        Book(
          id: '1',
          travelId: '1',
          userId: '1',
          dateOfTravel: DateTime.now(),
          dateOfBooking: DateTime.now(),
          amount: 1,
        ),
        Book(
          id: '2',
          travelId: '2',
          userId: '2',
          dateOfTravel: DateTime.now(),
          dateOfBooking: DateTime.now(),
          amount: 2,
        ),
      ];

      // Mock the behavior of fetchBookData() to return the mockBooks
      when(mockBookApi.fetchBookData()).thenAnswer((_) async => mockBooks);

      // Act
      final result = await mockBookApi.fetchBookData();

      // Assert
      expect(result, isA<List<Book>>());
      expect(result.length, 2);
      expect(result[0].id, '1');
    });

    test('Create a book returns a Book object', () async {
      // Arrange
      Book newBook = Book(
        id: '3',
        travelId: '3',
        userId: '3',
        dateOfTravel: DateTime.now(),
        dateOfBooking: DateTime.now(),
        amount: 3,
      );

      // Mock the behavior of createBook() to return the newBook
      when(mockBookApi.createBook(book: anyNamed('book')))
          .thenAnswer((_) async => newBook);

      // Act
      final result = await mockBookApi.createBook(book: newBook);

      // Assert
      expect(result, isA<Book>());
      expect(result.id, '3');
      expect(result.amount, 3);
    });
  });
}
