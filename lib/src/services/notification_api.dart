import 'package:dio/dio.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/notification_model.dart';
import 'package:velocity_app/src/services/api_service.dart';

enum FriendRequestResponse {
  accept,
  decline,
}

abstract class NotificationApi {
  Future<ApiResponse<List<NotificationModel>>> fetchNotifications({
    required String userId,
  });
  Future<ApiResponse<void>> sendFriendRequest({
    required String receiverId,
    required String senderId,
  });
  Future<ApiResponse<void>> respondToFriendRequest({
    required String notificationId,
    required FriendRequestResponse receiverResponse,
  });
}

class NotificationApiImpl extends NotificationApi {
  final baseUrl = GlobalData.baseUrl;
  Dio dio = Dio();

  @override
  Future<ApiResponse<List<NotificationModel>>> fetchNotifications(
      {required String userId}) async {
    try {
      final response = await dio
          .get('$baseUrl/notification/getNotificationByReceiverId/$userId');

      List<NotificationModel> notifications = [];

      response.data.forEach((notification) {
        notifications.add(NotificationModel.fromJson(notification));
      });

      return ApiResponse(data: notifications);
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }

  @override
  Future<ApiResponse<void>> sendFriendRequest({
    required String receiverId,
    required String senderId,
  }) async {
    try {
      await dio.post(
        '$baseUrl/notification/createNotification',
        data: {
          "type": "friendRequest",
          "receiver": receiverId,
          "sender": senderId,
        },
      );

      return ApiResponse();
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }

  @override
  Future<ApiResponse<void>> respondToFriendRequest({
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

      return ApiResponse();
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }
}
