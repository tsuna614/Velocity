import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_app/src/services/user_api.dart';
import 'package:velocity_app/src/bloc/post/post_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_events.dart';
import 'package:velocity_app/src/model/post_model.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/widgets/social-media/comment_screen.dart';

class Post extends StatefulWidget {
  const Post({super.key, required this.post});

  final MyPost post;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  MyUser? userData;
  bool _isLoading = true;
  late bool _isRatingPost;

  @override
  void initState() {
    _isRatingPost = widget.post.rating != null;
    _fetchUserData();
    super.initState();
  }

  Future<void> _fetchUserData() async {
    final fetchedUser = await GetIt.I<UserApiImpl>()
        .fetchUserDataById(userId: widget.post.userId);
    setState(() {
      userData = fetchedUser;
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

  Future<void> _handleCommentPressed(BuildContext context) async {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (builder) {
        return CommentScreen(postId: widget.post.postId);
      },
    );
  }

  String formattedDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const PostSkeleton();
    }

    return Card(
      color: Colors.white,
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildUserAvatarAndName(userData!),
                if (_isRatingPost) buildRatingRow(),
                const SizedBox(height: 10),
                buildPostContent(),
                const SizedBox(height: 8),
                buildPostImage(),
                const SizedBox(height: 8),
                buildActionsCounter(),
              ],
            ),
          ),
          buildPostActionsRow(),
        ],
      ),
    );
  }

  Widget buildRatingRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          for (var i = 0; i < 5; i++)
            widget.post.rating! - i <= 0
                ? const Icon(
                    Icons.star_border,
                    color: Colors.orange,
                    size: 18,
                  )
                : widget.post.rating! - i < 1
                    ? const Icon(
                        Icons.star_half,
                        color: Colors.orange,
                        size: 18,
                      )
                    : const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 18,
                      ),
          const SizedBox(width: 5),
          Text(
            "(${widget.post.rating})",
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
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
                "${userData.firstName} ${userData.lastName} ",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "${formattedDate(widget.post.dateCreated)} - ${userData.email}",
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

  Widget buildPostContent() {
    if (widget.post.content!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
      ),
      child: Text(
        widget.post.content!,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Widget buildPostImage() {
    if (widget.post.imageUrl!.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.network(
          widget.post.imageUrl!,
          fit: BoxFit.cover,
          // loading builder is to show a shimmer effect while the image is loading
          // but because of loadingProgress, the shimmer doesn't show immediately when buildPostImage is called
          // you can try commenting the if statement block to see the difference
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 200,
                color: Colors.grey.shade300,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildActionsCounter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          buildCounterTextSpan(widget.post.likes!.length, "Likes"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child:
                buildCounterTextSpan(widget.post.comments!.length, "Comments"),
          ),
          if (!_isRatingPost)
            buildCounterTextSpan(widget.post.shares!.length, "Shares"),
        ],
      ),
    );
  }

  Widget buildPostActionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        PostActionButton(
          label: "Like",
          actionType: ActionType.like,
          onPressed: _handleLikePressed,
          isActive: widget.post.likes?.contains(GlobalData.userId) ?? false,
        ),
        PostActionButton(
          label: "Comment",
          actionType: ActionType.comment,
          onPressed: () {
            _handleCommentPressed(context);
          },
          isActive: false,
        ),
        if (!_isRatingPost)
          PostActionButton(
            label: "Share",
            actionType: ActionType.share,
            onPressed: () {},
            isActive: false,
          ),
      ],
    );
  }

  Widget buildCounterTextSpan(int count, String label) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$count ",
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: label,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

enum ActionType { like, comment, share }

class PostActionButton extends StatelessWidget {
  const PostActionButton({
    super.key,
    required this.label,
    required this.actionType,
    required this.onPressed,
    required this.isActive,
  });

  final String label;
  final ActionType actionType;
  final Function() onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    IconData icon = actionType == ActionType.like
        ? Icons.thumb_up
        : actionType == ActionType.comment
            ? Icons.comment
            : Icons.share;

    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.blue : Colors.grey,
              ),
              const SizedBox(width: 10),
              Flexible(child: Text(label)),
            ],
          ),
        ),
      ),
    );
  }
}

class PostSkeleton extends StatelessWidget {
  const PostSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: const CircleAvatar(
                    radius: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 150,
                        height: 20,
                        color: Colors.grey.shade300,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 100,
                        height: 20,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Row(
            //   children: [
            //     const SkeletonActionButton(),
            //     const SkeletonActionButton(),
            //     const SkeletonActionButton(),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
