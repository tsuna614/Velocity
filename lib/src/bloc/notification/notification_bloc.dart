import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/notification/notification_events.dart';
import 'package:velocity_app/src/bloc/notification/notification_states.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/notification_model.dart';
import 'package:velocity_app/src/services/api_service.dart';
import 'package:velocity_app/src/services/notification_api.dart';

class NotificationBloc extends Bloc<NotificationEvents, NotificationState> {
  final NotificationApi notificationApi;

  NotificationBloc(this.notificationApi) : super(NotificationInitial()) {
    on<FetchNotifications>((event, emit) async {
      emit(NotificationLoading());
      final ApiResponse<List<NotificationModel>> response =
          await notificationApi.fetchNotificationsOfUser(
              userId: GlobalData.userId);
      if (response.errorMessage != null) {
        emit(NotificationFailure(error: response.errorMessage!));
      } else {
        emit(NotificationLoaded(notifications: response.data!));
      }
    });

    on<HandleFriendRequest>((event, emit) async {
      final ApiResponse<void> response =
          await notificationApi.respondToFriendRequest(
        notificationId: event.notificationId,
        receiverResponse: event.receiverResponse,
      );

      // filter out the notification that was responded to
      final updatedNotifications = (state as NotificationLoaded)
          .notifications
          .where((notification) => notification.id != event.notificationId)
          .toList();

      if (response.errorMessage != null) {
        emit(NotificationFailure(error: response.errorMessage!));
      } else {
        emit(NotificationLoaded(notifications: updatedNotifications));
      }
    });
  }
}
