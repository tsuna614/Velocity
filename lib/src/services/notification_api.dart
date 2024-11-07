import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/notification_model.dart';
import 'package:velocity_app/src/services/api_service.dart';

enum FriendRequestResponse {
  accept,
  decline,
}

abstract class NotificationApi {
  final ApiService apiService;
  NotificationApi(this.apiService);

  Future<ApiResponse<List<NotificationModel>>> fetchNotificationsOfUser({
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

  // Future<ApiResponse<bool>> checkIf({
  //   required String receiverId,
  //   required String senderId,
  // });
}

class NotificationApiImpl extends NotificationApi {
  final baseUrl = GlobalData.baseUrl;

  NotificationApiImpl(super.apiService);

  @override
  Future<ApiResponse<List<NotificationModel>>> fetchNotificationsOfUser(
      {required String userId}) async {
    return apiService.get(
      endpoint: '$baseUrl/notification/getNotificationByReceiverId/$userId',
      fromJson: (data) => (data as List)
          .map((notification) => NotificationModel.fromJson(notification))
          .toList(),
    );
  }

  @override
  Future<ApiResponse<void>> sendFriendRequest({
    required String receiverId,
    required String senderId,
  }) async {
    return apiService.post(
      endpoint: '$baseUrl/notification/createNotification',
      data: {
        "type": "friendRequest",
        "receiver": receiverId,
        "sender": senderId,
      },
    );
  }

  @override
  Future<ApiResponse<void>> respondToFriendRequest({
    required String notificationId,
    required FriendRequestResponse receiverResponse,
  }) async {
    return apiService.post(
      endpoint: '$baseUrl/notification/notificationResponse',
      data: {
        "notificationId": notificationId,
        "receiverResponse": receiverResponse == FriendRequestResponse.accept
            ? "accept"
            : "decline",
      },
    );
  }
}
