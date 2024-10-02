class MyPost {
  final String postId;
  final String userId;
  final DateTime dateCreated;
  final String? content;
  final String? imageUrl;
  final List<String>? likes;
  final List<String>? comments;
  final List<String>? shares;
  // these two fields are for the rating posts
  final double? rating;
  final String? travelId;
  // final DateTime dateCreated;

  MyPost({
    required this.postId,
    required this.userId,
    required this.dateCreated,
    this.content = "",
    this.imageUrl = "",
    this.likes = const [],
    this.comments = const [],
    this.shares = const [],
    this.rating,
    this.travelId,
  });

  MyPost copyWith({
    String? postId,
    String? userId,
    String? content,
    String? imageUrl,
    List<String>? likes,
    List<String>? comments,
    List<String>? shares,
    DateTime? dateCreated,
    double? rating,
    String? travelId,
  }) {
    return MyPost(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      dateCreated: dateCreated ?? this.dateCreated,
      rating: rating ?? this.rating,
      travelId: travelId ?? this.travelId,
    );
  }

  void printPost() {
    print(
      "rating: $rating, travelId: $travelId",
    );
  }
}
