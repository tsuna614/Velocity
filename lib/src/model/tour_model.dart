class Travel {
  final String title;
  final String description;
  final List<String> imageUrl;
  final String city;
  final double price;
  final double rating;

  Travel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.city,
    required this.price,
    required this.rating,
  });

  Travel copyWith({
    String? title,
    String? description,
    List<String>? imageUrl,
    String? city,
    double? price,
    double? rating,
  }) {
    return Travel(
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      city: city ?? this.city,
      price: price ?? this.price,
      rating: rating ?? this.rating,
    );
  }
}

class Tour extends Travel {
  final String destination;
  final String duration;
  final int capacity;

  Tour({
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.city,
    required super.price,
    required super.rating,
    required this.destination,
    required this.duration,
    this.capacity = 10,
  });

  @override
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
}

class Hotel extends Travel {
  final String address;
  final String contact;

  Hotel({
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.city,
    required super.price,
    required super.rating,
    required this.address,
    required this.contact,
  });

  @override
  Hotel copyWith({
    String? title,
    String? description,
    List<String>? imageUrl,
    String? city,
    double? price,
    double? rating,
    String? address,
    String? contact,
  }) {
    return Hotel(
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
}
