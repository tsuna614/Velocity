import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/widgets/social-media/create_post_sheet.dart';

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
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is! UserLoaded) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          children: [
            buildPostContainer(state),
          ],
        ),
      );
    });
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
                      backgroundImage: NetworkImage(state.user.profileImageUrl),
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
