import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:velocity_app/src/model/notification_model.dart';
import 'package:velocity_app/src/services/notification_api.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isLoading = true;
  late final List<NotificationModel> _notifications = [];

  @override
  void initState() {
    fetchNotifications();
    super.initState();
  }

  Future<void> fetchNotifications() async {
    final notifications = await NotificationApiImpl().fetchNotifications();
    setState(() {
      _notifications.addAll(notifications);
      _isLoading = false;
    });
  }

  Future<void> handleFriendRequestResponse(
      NotificationModel notification, FriendRequestResponse response) async {
    await GetIt.I<NotificationApiImpl>().respondToFriendRequest(
      notificationId: notification.id,
      receiverResponse: response,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                          "${_notifications[index].sender} sent you a friend request"),
                      subtitle: Text(_notifications[index].time.toString()),
                    ),
                    const Divider(),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            handleFriendRequestResponse(_notifications[index],
                                FriendRequestResponse.accept);
                          },
                          child: const Text('Accept'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            handleFriendRequestResponse(_notifications[index],
                                FriendRequestResponse.decline);
                          },
                          child: const Text('Decline'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
    );
  }
}
