import 'package:velocity_app/src/model/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationFailure extends NotificationState {
  final String error;

  NotificationFailure({required this.error});

  NotificationFailure copyWith({
    String? error,
  }) {
    return NotificationFailure(
      error: error ?? this.error,
    );
  }
}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;

  NotificationLoaded({required this.notifications});

  NotificationLoaded copyWith({
    List<NotificationModel>? notifications,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
    );
  }
}
