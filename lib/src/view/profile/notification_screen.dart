import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/main.dart';
import 'package:velocity_app/src/bloc/notification/notification_bloc.dart';
import 'package:velocity_app/src/bloc/notification/notification_events.dart';
import 'package:velocity_app/src/bloc/notification/notification_states.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_events.dart';
import 'package:velocity_app/src/model/notification_model.dart';
import 'package:velocity_app/src/services/general_api.dart';
import 'package:velocity_app/src/services/notification_api.dart';
import 'package:velocity_app/src/widgets/empty_indicator.dart';
import 'package:velocity_app/src/widgets/social-media/user/avatar_and_name.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<void> handleFriendRequestResponse({
    required NotificationModel notification,
    required FriendRequestResponse response,
    required BuildContext context,
  }) async {
    final notificationBloc = BlocProvider.of<NotificationBloc>(context);

    notificationBloc.add(
      HandleFriendRequest(
        notificationId: notification.id,
        receiverResponse: response,
      ),
    );

    final result = await notificationBloc.stream.firstWhere(
      (state) => state is NotificationLoaded || state is NotificationFailure,
    );

    if (!context.mounted) return;
    if (result is NotificationLoaded) {
      if (response == FriendRequestResponse.accept) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Friend added successfully'),
          ),
        );
        BlocProvider.of<UserBloc>(context)
            .add(AddFriend(friendId: notification.sender));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Friend request declined'),
          ),
        );
      }
    } else if (result is NotificationFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.error),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationBloc(getIt<NotificationApiImpl>())
        ..add(FetchNotifications()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
          if (state is! NotificationLoaded) {
            return const CircularProgressIndicator();
          }

          if (state.notifications.isEmpty) {
            return const Center(
              child: EmptyIndicator(message: "No notifications found."),
            );
          }

          return ListView.builder(
            itemCount: state.notifications.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: AvatarAndName(
                          userId: state.notifications[index].sender,
                          message: "has sent you a friend request.",
                        ),
                        trailing: Text(
                          GeneralApi.getTime(
                            state.notifications[index].time,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          buildStyledButton(
                            text: "Accept",
                            color: Colors.blue,
                            onPressed: () {
                              handleFriendRequestResponse(
                                notification: state.notifications[index],
                                response: FriendRequestResponse.accept,
                                context: context,
                              );
                            },
                          ),
                          buildStyledButton(
                            text: "Decline",
                            color: Colors.red,
                            onPressed: () {
                              handleFriendRequestResponse(
                                notification: state.notifications[index],
                                response: FriendRequestResponse.decline,
                                context: context,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget buildStyledButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: color,
        ),
        child: Text(text),
      ),
    );
  }
}
