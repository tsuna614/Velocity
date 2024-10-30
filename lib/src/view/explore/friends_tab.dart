import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/widgets/empty_indicator.dart';
import 'package:velocity_app/src/widgets/search_bar.dart';
import 'package:velocity_app/src/widgets/social-media/user/user_list_tile.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
        if (state is! UserLoaded) {
          return const CircularProgressIndicator();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MySearchBar(
              hintText: "Search friends",
              enableBorder: true,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "${state.user.friends.length} friends",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (state.user.friends.isEmpty)
              const Expanded(
                child: Center(
                  child:
                      EmptyIndicator(message: "No friends yet. Go make some!"),
                ),
              ),
            if (state.user.friends.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: state.user.friends.length,
                  itemBuilder: (context, index) {
                    return UserListTile(
                      key: ValueKey(state.user.friends[index]),
                      userId: state.user.friends[index],
                    );
                  },
                ),
              )
          ],
        );
      }),
    );
  }
}
