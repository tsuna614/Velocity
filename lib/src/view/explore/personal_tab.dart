import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_states.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/post_model.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/widgets/social-media/create_post_sheet.dart';
import 'package:velocity_app/src/widgets/social-media/post.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalTab extends StatefulWidget {
  const PersonalTab({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<PersonalTab> createState() => _PersonalTabState();
}

class _PersonalTabState extends State<PersonalTab> {
  void _showModalSheet(BuildContext context, MyUser user) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (builder) {
        return CreatePostSheet(
          userData: user,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            if (state is! UserLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            return buildPostContainer(state);
          }),
          BlocBuilder<PostBloc, PostState>(builder: (context, state) {
            if (state is! PostLoaded) {
              return ListView(
                controller: widget.scrollController,
                shrinkWrap: true,
                children: const <Widget>[
                  PostSkeleton(),
                  PostSkeleton(),
                  PostSkeleton(),
                  PostSkeleton(),
                ],
              );
            }

            List<MyPost> userPosts = state.posts
                .where((post) => post.userId == GlobalData.userId)
                .toList();

            return ListView.builder(
              shrinkWrap: true,
              controller: widget.scrollController,
              itemCount: userPosts.length,
              itemBuilder: (context, index) {
                return Post(post: userPosts[index]);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget buildPostContainer(UserLoaded state) {
    return Card(
      color: Colors.white,
      // padding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.posts,
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
                    Text(
                      AppLocalizations.of(context)!.whatsOnYourMindQuestion,
                      style: const TextStyle(
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
