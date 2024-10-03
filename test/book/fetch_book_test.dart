// test/book_api_test.dart

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:velocity_app/src/model/book_model.dart';
import 'package:velocity_app/src/services/book_api.dart';

// Generate a MockDio class
@GenerateMocks([Dio])
import 'fetch_book_test.mocks.dart'; // Import the generated mocks

void main() {
  late BookApiImpl bookApi;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    bookApi = BookApiImpl();
    bookApi.dio = mockDio; // Override the Dio instance with the mock
  });

  group('fetchBookData', () {
    test('should return a list of books on successful API call', () async {
      // Arrange
      final mockResponse = Response(
        data: [
          {
            '_id': '1',
            'travelId': '100',
            'userId': 'user_1',
            'bookedDate': '2023-10-01T12:00:00Z',
            'amount': 200,
          },
          {
            '_id': '2',
            'travelId': '101',
            'userId': 'user_2',
            'bookedDate': '2023-10-02T12:00:00Z',
            'amount': 300,
          }
        ],
        requestOptions: RequestOptions(path: '/book/getAllBooks'),
        statusCode: 200,
      );

      when(mockDio.get(any)).thenAnswer((_) async => mockResponse);

      // Act
      final books = await bookApi.fetchBookData();

      // Assert
      expect(books, isA<List<Book>>());
      expect(books.length, 2);
      expect(books[0].id, '1');
      expect(books[0].travelId, '100');
      expect(books[0].userId, 'user_1');
      expect(books[0].dateOfBooking, DateTime.parse('2023-10-01T12:00:00Z'));
      expect(books[0].dateOfTravel, DateTime.parse('2023-10-01T12:00:00Z'));
      expect(books[0].amount, 200);
    });

    test('should throw DioException on failed API call', () async {
      // Arrange
      final mockErrorResponse = Response(
        requestOptions: RequestOptions(path: '/book/getAllBooks'),
        statusCode: 500,
      );

      when(mockDio.get(any)).thenThrow(DioException(
        requestOptions: mockErrorResponse.requestOptions,
        response: mockErrorResponse,
        message: 'Internal Server Error',
      ));

      // Act & Assert
      expect(
        () async => await bookApi.fetchBookData(),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('createBook', () {
    test("should", () async {
      // Arrange
      final book = Book(
        id: '1',
        travelId: '100',
        userId: 'user_1',
        dateOfTravel: DateTime.parse('2023-10-01T12:00:00Z'),
        dateOfBooking: DateTime.now(),
        amount: 200,
      );

      final mockResponse = Response(
        data: {
          '_id': '1',
          'travelId': '100',
          'userId': 'user_1',
          'bookedDate': '2023-10-01T12:00:00Z',
          'amount': 200,
        },
        requestOptions: RequestOptions(path: '/book/createBook'),
        statusCode: 201,
      );

      when(mockDio.post(any, data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      // Act
      final createdBook = await bookApi.createBook(book: book);

      // Assert
      expect(createdBook, isA<Book>());
      expect(createdBook.id, '1');
      expect(createdBook.travelId, '100');
      expect(createdBook.userId, 'user_1');
      expect(createdBook.dateOfBooking, DateTime.parse('2023-10-01T12:00:00Z'));
      expect(createdBook.dateOfTravel, DateTime.parse('2023-10-01T12:00:00Z'));
      expect(createdBook.amount, 200);
    });
  });
}
