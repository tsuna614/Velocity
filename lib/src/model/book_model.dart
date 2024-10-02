class Book {
  final String id;
  final String travelId;
  final String userId;
  final DateTime dateOfTravel; // this is the datet the user chose to travel
  final DateTime dateOfBooking; // this is the date when the booking was made
  final int amount;

  Book({
    required this.id,
    required this.travelId,
    required this.userId,
    required this.dateOfTravel,
    required this.dateOfBooking,
    required this.amount,
  });

  Book copyWith({
    String? id,
    String? travelId,
    String? userId,
    DateTime? dateOfTravel,
    DateTime? dateOfBooking,
    int? amount,
  }) {
    return Book(
      id: id ?? this.id,
      travelId: travelId ?? this.travelId,
      userId: userId ?? this.userId,
      dateOfTravel: dateOfTravel ?? this.dateOfTravel,
      dateOfBooking: dateOfBooking ?? this.dateOfBooking,
      amount: amount ?? this.amount,
    );
  }

  // convert from json to book
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      travelId: json['travelId'],
      userId: json['userId'],
      dateOfTravel: DateTime.parse(json['bookedDate']),
      dateOfBooking:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      amount: json['amount'],
    );
  }

  // convert from book to json
  Map<String, dynamic> toJson() {
    return {
      'travelId': travelId,
      'userId': userId,
      'bookedDate': dateOfTravel.toIso8601String(),
      'createdAt': dateOfBooking.toIso8601String(),
      'amount': amount,
    };
  }
}
