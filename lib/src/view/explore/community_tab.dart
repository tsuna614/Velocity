import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_states.dart';
import 'package:velocity_app/src/widgets/social-media/post.dart';

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

      return ListView.builder(
        itemCount: state.posts.length,
        itemBuilder: (context, index) {
          return Post(post: state.posts[index]);
        },
      );
    });
  }
}
