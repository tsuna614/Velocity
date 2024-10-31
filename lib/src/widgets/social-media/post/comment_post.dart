import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_app/src/bloc/post/post_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_events.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/post_model.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/services/general_api.dart';
import 'package:velocity_app/src/services/user_api.dart';
import 'package:velocity_app/src/widgets/expandable_text.dart';

class CommentPost extends StatefulWidget {
  const CommentPost({super.key, required this.post});

  final PostModel post;

  @override
  State<CommentPost> createState() => _CommentPostState();
}

class _CommentPostState extends State<CommentPost> {
  UserModel? userData;
  bool _isLoading = true;

  Future<void> _fetchUserData() async {
    final response = await GetIt.I<UserApiImpl>()
        .fetchUserDataById(userId: widget.post.userId);
    setState(() {
      userData = response.data!;
      _isLoading = false;
    });
  }

  Future<void> _handleLikePressed() async {
    setState(() {
      // call the like post event of PostBloc
      BlocProvider.of<PostBloc>(context)
          .add(LikePost(postId: widget.post.postId, userId: GlobalData.userId));
    });
  }

  @override
  void initState() {
    _fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildUserAvatar(),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildContentBox(),
              buildActionRow(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildUserAvatar() {
    return _isLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: const CircleAvatar(
              radius: 20,
            ),
          )
        : CircleAvatar(
            radius: 20,
            backgroundImage: userData!.profileImageUrl.isEmpty
                ? const AssetImage('assets/images/user-placeholder.png')
                : NetworkImage(userData!.profileImageUrl),
          );
  }

  Widget buildContentBox() {
    return Container(
      constraints: const BoxConstraints(minWidth: 100),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isLoading
                  ? 'Loading...'
                  : '${userData!.firstName} ${userData!.lastName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            ExpandableText(text: widget.post.content!),
          ],
        ),
      ),
    );
  }

  Widget buildActionRow() {
    bool isLiked = widget.post.likes?.contains(GlobalData.userId) ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Text(GeneralApi.getTime(widget.post.dateCreated)),
          const SizedBox(width: 10),
          TextButton(
            onPressed: _handleLikePressed,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0),
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: isLiked ? Colors.blue : Colors.grey.shade800,
            ),
            child: const Text('Like'),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0),
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: Colors.grey.shade800,
            ),
            child: const Text('Reply'),
          ),
          const Spacer(),
          Text(
            '${widget.post.likes?.length ?? 0} likes',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class CommentPostSkeleton extends StatefulWidget {
  const CommentPostSkeleton({super.key});

  @override
  State<CommentPostSkeleton> createState() => _CommentPostSkeletonState();
}

class _CommentPostSkeletonState extends State<CommentPostSkeleton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildUserAvatar(),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildContentBox(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildUserAvatar() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: const CircleAvatar(
        radius: 20,
      ),
    );
  }

  Widget buildContentBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 100,
                height: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: double.infinity,
                height: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
