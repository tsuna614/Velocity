enum ContentType {
  image,
  video,
}

class PostModel {
  final String postId;
  final String userId;
  final DateTime dateCreated;
  final String? content;
  final String? imageUrl;
  final ContentType contentType;
  final List<String>? likes;
  final List<String>? comments;
  final List<String>? shares;
  // these fields are for the rating posts
  final double? rating;
  final String? travelId;
  // these fields are for the comment posts
  final String? commentTargetId; // the id of the post that this post comment on
  // these fields are for the shared posts
  final String? sharedPostId; // the id of the post that this post shared

  PostModel({
    required this.postId,
    required this.userId,
    required this.dateCreated,
    this.content = "",
    this.imageUrl = "",
    this.contentType = ContentType.image,
    this.likes = const [],
    this.comments = const [],
    this.shares = const [],
    this.rating,
    this.travelId,
    this.commentTargetId,
    this.sharedPostId,
  });

  PostModel copyWith({
    String? postId,
    String? userId,
    String? content,
    String? imageUrl,
    ContentType? contentType,
    List<String>? likes,
    List<String>? comments,
    List<String>? shares,
    DateTime? dateCreated,
    double? rating,
    String? travelId,
    String? commentTargetId,
    String? sharedPostId,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      contentType: contentType ?? this.contentType,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      dateCreated: dateCreated ?? this.dateCreated,
      rating: rating ?? this.rating,
      travelId: travelId ?? this.travelId,
      commentTargetId: commentTargetId ?? this.commentTargetId,
      sharedPostId: sharedPostId ?? this.sharedPostId,
    );
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['_id'],
      userId: json['userId'],
      dateCreated: DateTime.parse(json['createdAt']),
      content: json['content'] ?? "",
      imageUrl: json['imageUrl'] ?? "",
      contentType: json['contentType'] == "video"
          ? ContentType.video
          : ContentType.image,
      likes: json['likes'] != null
          ? json['likes'].map<String>((e) => e.toString()).toList()
          : [],
      comments: json['comments'] != null
          ? json['comments'].map<String>((e) => e.toString()).toList()
          : [],
      shares: json['shares'] != null
          ? json['shares'].map<String>((e) => e.toString()).toList()
          : [],
      rating: json["rating"] == null
          ? null
          : double.parse(json['rating'].toString()),
      travelId: json['travelId'],
      commentTargetId: json['postId'],
      sharedPostId: json['sharedPostId'],
    );
  }
}
