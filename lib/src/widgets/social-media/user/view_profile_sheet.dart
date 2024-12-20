import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_events.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/services/notification_api.dart';
import 'package:velocity_app/src/view/explore/messaging/message_screen.dart';
import 'package:velocity_app/src/widgets/social-media/user/user_top_banner.dart';

enum FriendState {
  isFriend,
  isNotFriend,
  isPending,
}

class ViewProfileSheet extends StatefulWidget {
  const ViewProfileSheet({super.key, required this.userData});

  final UserModel userData;

  @override
  State<ViewProfileSheet> createState() => _ViewProfileSheetState();
}

class _ViewProfileSheetState extends State<ViewProfileSheet> {
  Future<void> _sendFriendRequest() async {
    final response = await GetIt.I<NotificationApiImpl>().sendFriendRequest(
      receiverId: widget.userData.userId,
      senderId: GlobalData.userId,
    );
    if (!mounted) return;
    if (response.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.errorMessage!),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Friend request sent"),
      ),
    );
  }

  Future<void> _removeFriend() async {
    final userBloc = BlocProvider.of<UserBloc>(context);

    userBloc.add(
      RemoveFriend(
        friendId: widget.userData.userId,
      ),
    );

    final result = await userBloc.stream.firstWhere(
      (state) => state is UserLoaded || state is UserFailure,
    );

    if (!mounted) return;
    if (result is UserLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Friend removed successfully"),
        ),
      );
    } else if (result is UserFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
        ),
      );
    }
  }

  Future<void> _pushToMessageScreen(UserModel user) async {
    if (user.userId == GlobalData.userId) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MessageScreen(receiverData: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FriendState friendState =
        (BlocProvider.of<UserBloc>(context).state as UserLoaded)
                .user
                .friends
                .contains(widget.userData.userId)
            ? FriendState.isFriend
            : FriendState.isNotFriend;

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          UserTopBanner(
            userData: widget.userData,
            isUserAlreadyFriend: friendState == FriendState.isFriend,
            friendButtonCallback: friendState == FriendState.isFriend
                ? _removeFriend
                : _sendFriendRequest,
            messageButtonCallback: () => _pushToMessageScreen(widget.userData),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
