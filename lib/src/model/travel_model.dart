abstract class TravelModel {
  final String id;
  final String title;
  final String description;
  final List<String> imageUrl;
  final double price;
  final double rating;

  TravelModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.rating,
  });

  // TravelModel copyWith({
  //   String? title,
  //   String? description,
  //   List<String>? imageUrl,
  //   double? price,
  //   double? ratingPostsIds,
  // }) {
  //   return TravelModel(
  //     title: title ?? this.title,
  //     description: description ?? this.description,
  //     imageUrl: imageUrl ?? this.imageUrl,
  //     price: price ?? this.price,
  //     ratingPostsIds: ratingPostsIds ?? this.ratingPostsIds,
  //   );
  // }
}

class Tour extends TravelModel {
  final String destination;
  final String duration;
  final String city;
  final int capacity;

  Tour({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.price,
    required super.rating,
    required this.destination,
    required this.duration,
    required this.city,
    this.capacity = 10,
  });

  Tour copyWith({
    String? title,
    String? description,
    List<String>? imageUrl,
    String? city,
    double? price,
    double? rating,
    String? destination,
    String? duration,
    int? capacity,
  }) {
    return Tour(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      city: city ?? this.city,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      destination: destination ?? this.destination,
      duration: duration ?? this.duration,
      capacity: capacity ?? this.capacity,
    );
  }

  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      imageUrl: List<String>.from(json['imageUrl']),
      rating: double.parse(json['rating'].toString()),
      price: double.parse(json['price'].toString()),
      destination: json['destination'],
      duration: json['duration'],
      city: json['city'],
      capacity: json['capacity'] ?? 0,
    );
  }
}

class Hotel extends TravelModel {
  final String address;
  final String contact;
  final String city;

  Hotel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.price,
    required super.rating,
    required this.address,
    required this.contact,
    required this.city,
  });

  Hotel copyWith({
    String? title,
    String? description,
    List<String>? imageUrl,
    String? city,
    double? price,
    List<String>? ratingPostsIds,
    double? rating,
    String? address,
    String? contact,
  }) {
    return Hotel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      city: city ?? this.city,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      address: address ?? this.address,
      contact: contact ?? this.contact,
    );
  }

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      imageUrl: List<String>.from(json['imageUrl']),
      rating: double.parse(json['rating'].toString()),
      price: double.parse(json['price'].toString()),
      address: json['address'],
      contact: json['contact'],
      city: json['city'],
    );
  }
}

class Flight extends TravelModel {
  final String origin;
  final String destination;
  final String departureTime;
  final String arrivalTime;
  final String airline;

  Flight({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.price,
    required super.rating,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    this.airline = '',
  });

  Flight copyWith({
    String? title,
    String? description,
    List<String>? imageUrl,
    double? price,
    List<String>? ratingPostsIds,
    double? rating,
    String? origin,
    String? destination,
    String? departureTime,
    String? arrivalTime,
    String? airline,
  }) {
    return Flight(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      airline: airline ?? this.airline,
    );
  }

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      imageUrl: List<String>.from(json['imageUrl']),
      rating: double.parse(json['rating'].toString()),
      price: double.parse(json['price'].toString()),
      origin: json['origin'],
      destination: json['destination'],
      departureTime: json['departureTime'],
      arrivalTime: json['arrivalTime'],
      airline: json['airline'],
    );
  }
}

class CarRental extends TravelModel {
  final String location;
  final String contact;
  final String carType;

  CarRental({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.price,
    required super.rating,
    required this.location,
    required this.contact,
    required this.carType,
  });

  CarRental copyWith({
    String? title,
    String? description,
    List<String>? imageUrl,
    double? price,
    List<String>? ratingPostsIds,
    double? rating,
    String? location,
    String? contact,
    String? carType,
  }) {
    return CarRental(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      location: location ?? this.location,
      contact: contact ?? this.contact,
      carType: carType ?? this.carType,
    );
  }

  factory CarRental.fromJson(Map<String, dynamic> json) {
    return CarRental(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      imageUrl: List<String>.from(json['imageUrl']),
      rating: double.parse(json['rating'].toString()),
      price: double.parse(json['price'].toString()),
      location: json['location'],
      contact: json['contact'],
      carType: json['carType'],
    );
  }
}
