class MyPost {
  final String postId;
  final String userId;
  final DateTime dateCreated;
  final String? content;
  final String? imageUrl;
  final List<String>? likes;
  final List<String>? comments;
  final List<String>? shares;
  // final DateTime dateCreated;

  MyPost({
    required this.postId,
    required this.userId,
    this.content = "",
    this.imageUrl = "",
    required this.dateCreated,
    this.likes = const [],
    this.comments = const [],
    this.shares = const [],
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
    );
  }
}
