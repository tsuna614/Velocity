import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/main.dart';
import 'package:velocity_app/src/bloc/post/post_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_events.dart';
import 'package:velocity_app/src/bloc/post/post_states.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/post_model.dart';
import 'package:velocity_app/src/services/post_api.dart';
import 'package:velocity_app/src/widgets/social-media/comment_post.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.postId});

  final String postId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  Future<void> _submitPost(BuildContext context) async {
    if (_commentController.text.trim().isEmpty) {
      return Future.value();
    }

    BlocProvider.of<PostBloc>(context).add(
      AddPost(
        post: MyPost(
          postId: "placeholder",
          userId: GlobalData.userId,
          content: _commentController.text,
          dateCreated: DateTime.now(),
          commentTargetId: widget.postId,
        ),
      ),
    );

    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(getIt<PostApiImpl>())
        ..add(
          FetchPosts(
            postType: PostType.commentPost,
            targetId: widget.postId,
          ),
        ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Comments'),
        ),
        body: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Builder(
                    builder: (context) {
                      if (state is! PostLoaded) {
                        return ListView.builder(
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: CommentPostSkeleton(),
                            );
                          },
                        );
                      }

                      if (state.posts.isEmpty) {
                        return const Center(
                          child: Text("No comments yet."),
                        );
                      }

                      return ListView.builder(
                        itemCount: state.posts.length,
                        itemBuilder: (context, index) {
                          return Container(
                            key: ValueKey(state.posts[index].postId),
                            child: CommentPost(post: state.posts[index]),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const Divider(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: 'Write a comment...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _submitPost(context),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
