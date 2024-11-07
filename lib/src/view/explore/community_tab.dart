import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_events.dart';
import 'package:velocity_app/src/bloc/post/post_states.dart';
import 'package:velocity_app/src/widgets/social-media/post/post.dart';

class CommunityTab extends StatefulWidget {
  const CommunityTab({super.key});

  @override
  State<CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends State<CommunityTab> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
      if (state is! PostLoaded) {
        return const Center(child: CircularProgressIndicator());
      }

      return RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<PostBloc>(context)
              .add(FetchPosts(postType: PostType.normalPost));
        },
        // child: ListView.builder(
        //   shrinkWrap: true,
        //   itemCount: state.posts.length,
        //   itemBuilder: (context, index) {
        //     return Post(
        //       key: ValueKey(state.posts[index].postId),
        //       post: state.posts[index],
        //     );
        //   },
        // ),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Post(
                    key: ValueKey(state.posts[index].postId),
                    post: state.posts[index],
                  );
                },
                childCount: state.posts.length,
              ),
            ),
          ],
        ),
        // child: SingleChildScrollView(
        //   child: Column(
        //     children: [
        //       for (var post in state.posts)
        //         Post(
        //           key: ValueKey(post.postId),
        //           post: post,
        //         ),
        //     ],
        //   ),
        // ),
      );
    });
  }
}
