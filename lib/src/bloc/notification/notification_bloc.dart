import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/notification/notification_events.dart';
import 'package:velocity_app/src/bloc/notification/notification_states.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/services/notification_api.dart';

class NotificationBloc extends Bloc<NotificationEvents, NotificationState> {
  final NotificationApi notificationApi;

  NotificationBloc(this.notificationApi) : super(NotificationInitial()) {
    on<FetchNotifications>((event, emit) async {
      emit(NotificationLoading());
      try {
        final notifications =
            await notificationApi.fetchNotifications(userId: GlobalData.userId);
        emit(NotificationLoaded(notifications: notifications));
      } on DioException catch (e) {
        emit(NotificationFailure(error: e.response!.data!));
      }
    });

    on<HandleFriendRequest>((event, emit) async {
      try {
        await notificationApi.respondToFriendRequest(
          notificationId: event.notificationId,
          receiverResponse: event.receiverResponse,
        );

        // filter out the notification that was responded to
        final updatedNotifications = (state as NotificationLoaded)
            .notifications
            .where((notification) => notification.id != event.notificationId)
            .toList();

        emit(NotificationLoaded(notifications: updatedNotifications));
      } on DioException catch (e) {
        emit(NotificationFailure(error: e.response!.data!));
      }
    });
  }
}
