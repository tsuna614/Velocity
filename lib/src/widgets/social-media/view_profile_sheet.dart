import 'package:flutter/material.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/view/explore/messaging/message_screen.dart';

class ViewProfileSheet extends StatefulWidget {
  const ViewProfileSheet({super.key, required this.userData});

  final MyUser userData;

  @override
  State<ViewProfileSheet> createState() => _ViewProfileSheetState();
}

class _ViewProfileSheetState extends State<ViewProfileSheet> {
  Future<void> _sendFriendRequest() async {}

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
                    onPressed: _sendFriendRequest,
                    child: const Text("Send Friend Request"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pushToMessageScreen(widget.userData),
                    child: const Text("Message"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
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
