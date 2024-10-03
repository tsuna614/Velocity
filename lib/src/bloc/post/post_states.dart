import 'package:velocity_app/src/model/post_model.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<MyPost> posts;

  PostLoaded({required this.posts});

  PostLoaded copyWith({
    List<MyPost>? posts,
  }) {
    return PostLoaded(
      posts: posts ?? this.posts,
    );
  }
}
