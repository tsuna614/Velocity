import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_app/main.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/services/user_api.dart';
import 'package:velocity_app/src/widgets/social-media/user/view_profile_sheet.dart';

class UserListTile extends StatefulWidget {
  const UserListTile({super.key, required this.userId});

  final String userId;

  @override
  State<UserListTile> createState() => _UserListTileState();
}

class _UserListTileState extends State<UserListTile> {
  late final MyUser userData;
  bool _isLoading = true;

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  Future<void> fetchUserData() async {
    final response =
        await getIt<UserApiImpl>().fetchUserDataById(userId: widget.userId);
    setState(() {
      userData = response;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return buildShimmer();
    }

    return Card(
      color: Colors.white,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return ViewProfileSheet(userData: userData);
              });
        },
        child: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: userData.profileImageUrl.isEmpty
                ? const AssetImage("assets/images/user-placeholder.png")
                : NetworkImage(userData.profileImageUrl),
          ),
          title: Text('${userData.firstName} ${userData.lastName}'),
          subtitle: Text(userData.email),
        ),
      ),
    );
  }

  Widget buildShimmer() {
    return ListTile(
      leading: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
        ),
      ),
      title: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 10,
          color: Colors.white,
        ),
      ),
      subtitle: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 10,
          color: Colors.white,
        ),
      ),
    );
  }
}
