import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_states.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/post_model.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/widgets/social-media/post/create_post_sheet.dart';
import 'package:velocity_app/src/widgets/social-media/post/post.dart';
import 'package:velocity_app/l10n/app_localizations.dart';
import 'package:velocity_app/src/widgets/social-media/user/user_top_banner.dart';

class PersonalTab extends StatefulWidget {
  const PersonalTab({super.key});

  @override
  State<PersonalTab> createState() => _PersonalTabState();
}

class _PersonalTabState extends State<PersonalTab> {
  void _showModalSheet(BuildContext context, UserModel user) {
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
    return ListView(
      children: [
        BlocBuilder<UserBloc, UserState>(builder: (context, state) {
          if (state is! UserLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              UserTopBanner(userData: state.user),
              const SizedBox(height: 10),
              buildPostContainer(state.user),
            ],
          );
        }),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Divider(),
        ),
        BlocBuilder<PostBloc, PostState>(builder: (context, state) {
          if (state is! PostLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          List<PostModel> userPosts = state.posts
              .where((post) => post.userId == GlobalData.userId)
              .toList();

          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: userPosts.length,
            itemBuilder: (context, index) {
              return Post(
                key: ValueKey(state.posts[index].postId),
                post: userPosts[index],
              );
            },
          );
        }),
      ],
    );
  }

  Widget buildPostContainer(UserModel user) {
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
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                _showModalSheet(context, user);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: user.profileImageUrl.isEmpty
                          ? const AssetImage(
                              "assets/images/user-placeholder.png")
                          : NetworkImage(user.profileImageUrl),
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
