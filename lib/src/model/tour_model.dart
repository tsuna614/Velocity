class Travel {
  final String name;
  final String description;
  final List<String> imageUrl;
  final String city;
  final double price;
  final double rating;

  Travel({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.city,
    required this.price,
    required this.rating,
  });

  Travel copyWith({
    String? name,
    String? description,
    List<String>? imageUrl,
    String? city,
    double? price,
    double? rating,
  }) {
    return Travel(
      name: name ?? this.name,
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

  Tour({
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.city,
    required super.price,
    required super.rating,
    required this.destination,
    required this.duration,
  });

  @override
  Tour copyWith({
    String? name,
    String? description,
    List<String>? imageUrl,
    String? city,
    double? price,
    double? rating,
    String? destination,
    String? duration,
  }) {
    return Tour(
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      city: city ?? this.city,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      destination: destination ?? this.destination,
      duration: duration ?? this.duration,
    );
  }
}

class Hotel extends Travel {
  final String address;
  final String contact;

  Hotel({
    required super.name,
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
    String? name,
    String? description,
    List<String>? imageUrl,
    String? city,
    double? price,
    double? rating,
    String? address,
    String? contact,
  }) {
    return Hotel(
      name: name ?? this.name,
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
