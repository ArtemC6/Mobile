part of 'notification_cubit.dart';

class NotificationState extends Equatable {
  const NotificationState({
    required this.user,
    this.systemNotificationTiketToken = '',
    this.operationId,
    this.notification,
  });
  final User user;
  final String? systemNotificationTiketToken;
  final String? operationId;
  final NewNotification? notification;

  NotificationState copyWith({
    User? user,
    String? systemNotificationTiketToken,
    String? operationId,
    NewNotification? notification,
  }) {
    return NotificationState(
      user: user ?? this.user,
      systemNotificationTiketToken:
          systemNotificationTiketToken ?? this.systemNotificationTiketToken,
      operationId: operationId ?? this.operationId,
      notification: notification ?? this.notification,
    );
  }

  @override
  List<Object?> get props => [
        user,
        systemNotificationTiketToken,
        operationId,
        notification,
      ];
}
