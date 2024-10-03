import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/main.dart';
import 'package:velocity_app/src/bloc/post/post_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_events.dart';
import 'package:velocity_app/src/bloc/post/post_states.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/model/travel_model.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/services/post_api.dart';
import 'package:velocity_app/src/widgets/social-media/create_post_sheet.dart';
import 'package:velocity_app/src/widgets/social-media/post.dart';

class RatingPage extends StatefulWidget {
  final Travel travelData;
  const RatingPage({
    super.key,
    required this.travelData,
  });

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  void _showModalSheet(BuildContext context, MyUser user) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (builder) {
        return CreatePostSheet(
          userData: user,
          travelId: widget.travelData.id,
          postBloc: BlocProvider.of<PostBloc>(context),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(getIt<PostApiImpl>())
        ..add(FetchPosts(
          isReviewPost: true,
          travelId: widget.travelData.id,
        )),
      // this blocbuilder will listen to the state of PostBloc that is the nearest on the widget tree (hopefully)
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rating'),
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            BlocBuilder<UserBloc, UserState>(builder: (context, state) {
              if (state is! UserLoaded) {
                return const Center(child: CircularProgressIndicator());
              }
              return buildPostContainer(context, state);
            }),
            Expanded(
              child: BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if (state is! PostLoaded) {
                    return ListView(
                      shrinkWrap: true,
                      children: const <Widget>[
                        PostSkeleton(),
                        PostSkeleton(),
                        PostSkeleton(),
                        PostSkeleton(),
                      ],
                    );
                  }

                  if (state.posts.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        "This travel page doesn't have any ratings yet",
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.posts.length,
                    itemBuilder: (context, index) {
                      return Post(post: state.posts[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPostContainer(BuildContext context, UserLoaded state) {
    return Card(
      color: Colors.white,
      // padding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Posts",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                _showModalSheet(context, state.user);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        state.user.profileImageUrl.isEmpty
                            ? "https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg"
                            : state.user.profileImageUrl,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "What's on your mind?",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.photo),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
