import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/api/user_api.dart';
import 'package:velocity_app/src/bloc/post/post_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_events.dart';
import 'package:velocity_app/src/model/post_model.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/data/global_data.dart' as global_data;

class Post extends StatefulWidget {
  const Post({super.key, required this.post});

  final MyPost post;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  MyUser? userData;
  bool _isLoading = true;

  @override
  void initState() {
    _fetchUserData();
    super.initState();
  }

  Future<void> _fetchUserData() async {
    final fetchedUser =
        await UserApi().fetchUserDataById(userId: widget.post.userId);
    setState(() {
      userData = fetchedUser;
      _isLoading = false;
    });
  }

  Future<void> _handleLikePressed() async {
    setState(() {
      // call the like post event of PostBloc
      BlocProvider.of<PostBloc>(context).add(
          LikePost(postId: widget.post.postId, userId: global_data.userId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _isLoading
                ? const CircularProgressIndicator()
                : buildUserAvatarAndName(userData!),
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                left: 8.0,
                right: 8.0,
                bottom: 8.0,
              ),
              child: Text(
                widget.post.content,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            buildPostImage(),
            buildPostActionsRow(),
          ],
        ),
      ),
    );
  }

  Widget buildUserAvatarAndName(MyUser userData) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            userData.profileImageUrl.isNotEmpty
                ? userData.profileImageUrl
                : "https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg",
          ),
          radius: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${userData.firstName} ${userData.lastName}",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                userData.email,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPostImage() {
    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.network(
          widget.post.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildPostActionsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          PostActionButton(
            icon: Icons.favorite,
            onPressed: _handleLikePressed,
            amount: widget.post.likes?.length ?? 0,
            isActive: widget.post.likes?.contains(global_data.userId) ?? false,
          ),
          PostActionButton(
            icon: Icons.comment,
            onPressed: () {},
            amount: widget.post.comments?.length ?? 0,
            isActive: false,
          ),
          PostActionButton(
            icon: Icons.share,
            onPressed: () {},
            amount: widget.post.shares?.length ?? 0,
            isActive: false,
          ),
        ],
      ),
    );
  }
}

class PostActionButton extends StatelessWidget {
  const PostActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.amount,
    required this.isActive,
  });

  final IconData icon;
  final Function() onPressed;
  final int amount;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 32.0),
      child: Row(
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(icon),
            color: isActive ? Colors.red : Colors.grey,
          ),
          Text(amount.toString()),
        ],
      ),
    );
  }
}
