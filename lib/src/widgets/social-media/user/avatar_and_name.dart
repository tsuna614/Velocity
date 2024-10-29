import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_app/main.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/services/user_api.dart';

class AvatarAndName extends StatefulWidget {
  const AvatarAndName({super.key, required this.userId, this.message});
  final String? message;
  final String userId;

  @override
  State<AvatarAndName> createState() => _AvatarAndNameState();
}

class _AvatarAndNameState extends State<AvatarAndName> {
  late final MyUser userData;
  bool _isLoading = true;

  Future<void> fetchUserData() async {
    final response =
        await getIt<UserApiImpl>().fetchUserDataById(userId: widget.userId);
    setState(() {
      userData = response.data!;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return buildShimmer();
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: userData.profileImageUrl.isEmpty
              ? const AssetImage("assets/images/user-placeholder.png")
              : NetworkImage(userData.profileImageUrl),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
              "${userData.firstName} ${userData.lastName} ${widget.message ?? ''}"),
        ),
      ],
    );
  }

  Widget buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 10),
          Container(
            height: 20,
            width: 100,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
