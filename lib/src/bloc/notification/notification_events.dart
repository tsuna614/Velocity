import 'package:velocity_app/src/services/notification_api.dart';

abstract class NotificationEvents {}

class FetchNotifications extends NotificationEvents {}

class HandleFriendRequest extends NotificationEvents {
  final String notificationId;
  final FriendRequestResponse receiverResponse;

  HandleFriendRequest(
      {required this.notificationId, required this.receiverResponse});
}
