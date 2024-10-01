import 'package:flutter_bloc/flutter_bloc.dart';
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
      // final List<MyPost> posts = await GeneralApi().fetchPosts();
      // emit(PostLoaded(posts: posts));
      final posts = await postApi.fetchPosts(isReviewPost: false);
      // emit(PostLoaded(posts: dummy_data.dummyPosts));
      emit(PostLoaded(
        posts: posts,
      ));
    });

    on<AddPost>((event, emit) async {
      // Call the API to add a post
      if (state is PostLoaded) {
        MyPost newPost = event.post;

        // send post request to server and get back the _id
        String postId = await postApi.addPost(post: newPost);
        newPost = newPost.copyWith(postId: postId);
        // add new post to the top of the list (newest -> oldest)
        List<MyPost> updatedPosts = [newPost, ...(state as PostLoaded).posts];

        emit(PostLoaded(
          posts: updatedPosts,
        ));
      }
    });

    on<DeletePost>((event, emit) async {
      // Call the API to delete a post
      // await GeneralApi().deletePost(postId: event.postId);
      // add(FetchPosts());
    });

    on<LikePost>((event, emit) async {
      if (state is PostLoaded) {
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
                  ? targetPost.likes!.where((id) => id != event.userId).toList()
                  : [...targetPost.likes!, event.userId],
        );

        // make a copy of the posts list with the changes we made
        List<MyPost> updatedPosts = (state as PostLoaded).posts.map((post) {
          return post.postId == event.postId ? targetPost : post;
        }).toList();

        // send api request to server
        await postApi.likePost(
          postId: event.postId,
          userId: event.userId,
        );

        // emit the updated list
        emit(PostLoaded(
          posts: updatedPosts,
        ));
      }
    });
  }
}
