class UserModel {
  final String userId;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final List<String> bookmarkedTravels;
  final List<String> friends;
  final String profileImageUrl;
  final String accessToken;
  final String refreshToken;

  UserModel({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.bookmarkedTravels = const [],
    this.friends = const [],
    required this.profileImageUrl,
    this.accessToken = '',
    this.refreshToken = '',
  });

  UserModel copyWith({
    String? userId,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    List<String>? bookmarkedTravels,
    List<String>? friends,
    String? profileImageUrl,
  }) {
    return UserModel(
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

  // convert fron JSON to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['_id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['number'],
      profileImageUrl: json['profileImageUrl'] ?? "",
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      bookmarkedTravels: json["bookmarkedTravels"] != null
          ? List<String>.from(json["bookmarkedTravels"])
          : [],
      friends: json["userFriends"] != null
          ? List<String>.from(json["userFriends"])
          : [],
    );
  }

  // convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'bookmarkedTravels': bookmarkedTravels,
      'friends': friends,
      'profileImageUrl': profileImageUrl,
    };
  }
}
