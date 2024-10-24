import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/widgets/empty_indicator.dart';
import 'package:velocity_app/src/widgets/social-media/user/user_list_tile.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is! UserLoaded) {
        return const CircularProgressIndicator();
      }

      if (state.user.friends.isEmpty) {
        return const Center(
          child: EmptyIndicator(message: "No friends yet. Go make some!"),
        );
      }

      return ListView.builder(
        itemCount: state.user.friends.length,
        controller: widget.scrollController,
        itemBuilder: (context, index) {
          return UserListTile(
            key: ValueKey(state.user.friends[index]),
            userId: state.user.friends[index],
          );
        },
      );
    });
  }
}
