import 'package:velocity_app/src/model/post_model.dart';

enum PostType {
  normalPost,
  reviewPost,
  commentPost,
}

abstract class PostEvent {}

class FetchPosts extends PostEvent {
  final PostType postType;
  final String? targetId;

  FetchPosts({required this.postType, this.targetId});
}

class AddPost extends PostEvent {
  final MyPost post;

  AddPost({required this.post});
}

class DeletePost extends PostEvent {
  final String postId;

  DeletePost({required this.postId});
}

class LikePost extends PostEvent {
  final String postId;
  final String userId;

  LikePost({required this.postId, required this.userId});
}
