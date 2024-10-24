class MyUser {
  final String userId;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final List<String> bookmarkedTravels;
  final List<String> friends;
  final String profileImageUrl;

  MyUser({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.bookmarkedTravels = const [],
    this.friends = const [],
    required this.profileImageUrl,
  });

  MyUser copyWith({
    String? userId,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    List<String>? bookmarkedTravels,
    List<String>? friends,
    String? profileImageUrl,
  }) {
    return MyUser(
      // double question mark means if the first is null, use the second instead
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      bookmarkedTravels: bookmarkedTravels ?? this.bookmarkedTravels,
      friends: friends ?? this.friends,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
