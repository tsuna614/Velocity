import 'package:dio/dio.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/notification_model.dart';

enum FriendRequestResponse {
  accept,
  decline,
}

abstract class NotificationApi {
  Future<List<NotificationModel>> fetchNotifications();
  Future<void> sendFriendRequest({
    required String receiverId,
    required String senderId,
  });
  Future<void> respondToFriendRequest({
    required String notificationId,
    required FriendRequestResponse receiverResponse,
  });
}

class NotificationApiImpl extends NotificationApi {
  final baseUrl = GlobalData.baseUrl;
  Dio dio = Dio();

  @override
  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final response = await dio.get(
          '$baseUrl/notification/getNotificationByReceiverId/${GlobalData.userId}');

      List<NotificationModel> notifications = [];

      response.data.forEach((notification) {
        notifications.add(NotificationModel.fromJson(notification));
      });

      return notifications;
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message,
      );
    }
  }

  @override
  Future<void> sendFriendRequest({
    required String receiverId,
    required String senderId,
  }) async {
    try {
      await dio.post(
        '$baseUrl/notification/sendFriendRequest',
        data: {
          "type": "friendRequest",
          "receiver": receiverId,
          "sender": senderId,
        },
      );
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message,
      );
    }
  }

  @override
  Future<void> respondToFriendRequest({
    required String notificationId,
    required FriendRequestResponse receiverResponse,
  }) async {
    try {
      await dio.post(
        '$baseUrl/notification/notificationResponse',
        data: {
          "notificationId": notificationId,
          "receiverResponse": receiverResponse == FriendRequestResponse.accept
              ? "accept"
              : "decline",
        },
      );
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message,
      );
    }
  }
}
