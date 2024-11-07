import 'package:flutter/material.dart';
import 'package:velocity_app/main.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/services/post_api.dart';

class UserTopBanner extends StatefulWidget {
  final UserModel userData;
  final bool? isUserAlreadyFriend;
  final void Function()? friendButtonCallback;
  final void Function()? messageButtonCallback;
  const UserTopBanner({
    super.key,
    required this.userData,
    this.isUserAlreadyFriend,
    this.friendButtonCallback,
    this.messageButtonCallback,
  });

  @override
  State<UserTopBanner> createState() => _UserTopBannerState();
}

class _UserTopBannerState extends State<UserTopBanner> {
  final double _avatarRadius = 50;
  final double _topSpacing = 30;
  int _postCount = 0;
  int _likeCount = 0;

  @override
  void initState() {
    fetchPostAmount();
    super.initState();
  }

  Future<void> fetchPostAmount() async {
    final response = await getIt<PostApiImpl>()
        .fetchPostsAmount(userId: widget.userData.userId);
    if (response.data == null) return;
    setState(() {
      _postCount = response.data!["totalPosts"];
      _likeCount = response.data!["totalLikes"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: _avatarRadius * 4 + _topSpacing,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: _avatarRadius + _topSpacing,
            left: 20,
            right: 20,
          ),
          child: buildUserInfoCard(),
        ),
        Padding(
          padding: EdgeInsets.only(top: _topSpacing),
          child: Center(
            child: buildAvatar(),
          ),
        ),
      ],
    );
  }

  Widget buildAvatar() {
    return Column(
      children: [
        Container(
          width: _avatarRadius * 2,
          height: _avatarRadius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white, // Border color
              width: 4.0, // Border width
            ),
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: widget.userData.profileImageUrl.isEmpty
                ? const AssetImage("assets/images/user-placeholder.png")
                : NetworkImage(widget.userData.profileImageUrl),
          ),
        ),
      ],
    );
  }

  Widget buildUserInfoCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: _avatarRadius + 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${widget.userData.firstName} ${widget.userData.lastName}",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.userData.email,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            buildUserStats(),
            if (widget.isUserAlreadyFriend != null) buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          buildButton(
            label: widget.isUserAlreadyFriend! ? "Remove Friend" : "Add Friend",
            icon: widget.isUserAlreadyFriend!
                ? Icons.person_remove
                : Icons.person_add,
            backgroundColor: Colors.grey[300]!,
            foregroundColor: Colors.black,
            onTap: widget.friendButtonCallback!,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: buildButton(
              label: "Message",
              icon: Icons.message,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              onTap: widget.messageButtonCallback!,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton({
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color foregroundColor,
    required void Function() onTap,
  }) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: foregroundColor,
                  size: 16,
                ),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUserStats() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildUserStatColumn(
              value: widget.userData.friends.length.toString(),
              label: "Friends"),
          customVerticalDivider(),
          buildUserStatColumn(value: _postCount.toString(), label: "Posts"),
          customVerticalDivider(),
          buildUserStatColumn(value: _likeCount.toString(), label: "Likes"),
        ],
      ),
    );
  }

  Widget buildUserStatColumn({required String value, required String label}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget customVerticalDivider() {
    return Container(
      width: 1, // Divider width
      height: 50, // Set the height you want for the divider
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Border color
          width: 1, // Border width
        ),
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
    );
  }
}
