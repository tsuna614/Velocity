import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';

class AvatarAndName extends StatefulWidget {
  const AvatarAndName({super.key});

  @override
  State<AvatarAndName> createState() => _AvatarAndNameState();
}

class _AvatarAndNameState extends State<AvatarAndName> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is! UserLoaded) {
          return const CircularProgressIndicator();
        }

        print(state.user.profileImageUrl);

        return Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: state.user.profileImageUrl.isEmpty
                  ? const AssetImage("assets/images/user-placeholder.png")
                  : NetworkImage(state.user.profileImageUrl),
            ),
            const SizedBox(width: 10),
            Text("${state.user.firstName} ${state.user.lastName}"),
          ],
        );
      },
    );
  }
}
