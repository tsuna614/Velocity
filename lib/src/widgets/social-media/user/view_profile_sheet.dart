import 'package:dio/dio.dart';
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

class ViewProfileSheet extends StatefulWidget {
  const ViewProfileSheet({super.key, required this.userData});

  final MyUser userData;

  @override
  State<ViewProfileSheet> createState() => _ViewProfileSheetState();
}

class _ViewProfileSheetState extends State<ViewProfileSheet> {
  Future<void> _sendFriendRequest() async {
    try {
      await GetIt.I<NotificationApiImpl>().sendFriendRequest(
        receiverId: widget.userData.userId,
        senderId: GlobalData.userId,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Friend request sent"),
        ),
      );
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    }
    Navigator.of(context).pop();
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

    Navigator.of(context).pop();
  }

  Future<void> _pushToMessageScreen(MyUser user) async {
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
    bool isUserAlreadyFriend =
        (BlocProvider.of<UserBloc>(context).state as UserLoaded)
            .user
            .friends
            .contains(widget.userData.userId);

    return Container(
      height: 200,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: widget.userData.profileImageUrl.isEmpty
                      ? const AssetImage("assets/images/user-placeholder.png")
                      : NetworkImage(widget.userData.profileImageUrl),
                  radius: 30,
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.userData.firstName} ${widget.userData.lastName}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(widget.userData.email),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isUserAlreadyFriend
                        ? _removeFriend
                        : _sendFriendRequest,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          isUserAlreadyFriend ? Colors.red : Colors.blue,
                    ),
                    child: Text(
                      isUserAlreadyFriend
                          ? "Remove Friend"
                          : "Send Friend Request",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pushToMessageScreen(widget.userData),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text("Message"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
