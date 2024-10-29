import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/services/api_response.dart';
import 'package:velocity_app/src/services/post_api.dart';
import 'package:velocity_app/src/bloc/post/post_events.dart';
import 'package:velocity_app/src/bloc/post/post_states.dart';
import 'package:velocity_app/src/model/post_model.dart';
// import '../../data/dummy_data.dart' as dummy_data;

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostApi postApi;

  PostBloc(this.postApi) : super(PostInitial()) {
    on<FetchPosts>((event, emit) async {
      emit(PostLoading());
      // Call the API to fetch the posts
      final ApiResponse<List<MyPost>> response = await postApi.fetchPosts(
        postType: event.postType,
        targetId: event.targetId,
      );
      if (response.data != null) {
        emit(PostLoaded(posts: response.data!));
      } else {
        emit(PostFailure(message: response.errorMessage!));
      }
    });

    on<AddPost>((event, emit) async {
      // Call the API to add a post
      if (state is PostLoaded) {
        MyPost newPost = event.post;

        // send post request to server and get back the _id
        ApiResponse<String> response = await postApi.addPost(post: newPost);

        if (response.errorMessage == null) {
          newPost = newPost.copyWith(postId: response.data);
          // add new post to the top of the list (newest -> oldest)
          List<MyPost> updatedPosts = [newPost, ...(state as PostLoaded).posts];
          emit(PostLoaded(posts: updatedPosts));
        } else {
          emit(PostFailure(message: response.errorMessage!));
        }
      }
    });

    on<DeletePost>((event, emit) async {
      if (state is PostLoaded) {
        // send api request to server
        final ApiResponse<void> response =
            await postApi.deletePost(postId: event.postId);

        if (response.errorMessage == null) {
          // filter out the post that need deleting by postId
          List<MyPost> updatedPosts = (state as PostLoaded)
              .posts
              .where((post) => post.postId != event.postId)
              .toList();
          emit(PostLoaded(posts: updatedPosts));
        } else {
          emit(PostFailure(message: response.errorMessage!));
        }
      }
    });

    on<LikePost>((event, emit) async {
      if (state is PostLoaded) {
        // send api request to server
        final ApiResponse<void> response = await postApi.likePost(
          postId: event.postId,
          userId: event.userId,
        );

        if (response.errorMessage == null) {
          // find the post that need changing by postId
          MyPost targetPost = (state as PostLoaded)
              .posts
              .where((post) => post.postId == event.postId)
              .first;

          // upon acquiring the post, make the change to it
          targetPost = targetPost.copyWith(
            likes:
                // // add this when the likes field not yet initialized
                // targetPost.likes == null
                //     ? targetPost.likes = [event.userId]
                //     :
                targetPost.likes!.contains(event.userId)
                    ? targetPost.likes!
                        .where((id) => id != event.userId)
                        .toList()
                    : [...targetPost.likes!, event.userId],
          );

          // make a copy of the posts list with the changes we made
          List<MyPost> updatedPosts = (state as PostLoaded).posts.map((post) {
            return post.postId == event.postId ? targetPost : post;
          }).toList();

          emit(PostLoaded(posts: updatedPosts));
        } else {
          emit(PostFailure(message: response.errorMessage!));
        }
      }
    });
  }
}
