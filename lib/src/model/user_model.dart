class MyUser {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final List<String> bookmarkedTravels;

  MyUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    this.bookmarkedTravels = const [],
  });

  MyUser copyWith({
    String? userId,
    String? name,
    String? email,
    String? phone,
    List<String>? bookmarkedTravels,
  }) {
    return MyUser(
      // double question mark means if the first is null, use the second instead
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bookmarkedTravels: bookmarkedTravels ?? this.bookmarkedTravels,
    );
  }
}
