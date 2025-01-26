import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter__clone/apis/notification_api.dart';
import 'package:twitter__clone/core/enums/notification_type_enum.dart';
import 'package:twitter__clone/core/utils.dart';
import 'package:twitter__clone/models/notification_model.dart';

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>((ref) {
  return NotificationController(
      notificationApi: ref.watch(notificationAPIProvider));
});

final getLatestNotificationProvider = StreamProvider((ref) {
  final notificationApi = ref.watch(notificationAPIProvider);
  return notificationApi.getLatestNotification();
});

final getNotificationsProvider = FutureProvider.family((ref, String uid) async {
  final notificationController =
      ref.watch(notificationControllerProvider.notifier);
  return notificationController.getNotifications(uid);
});

class NotificationController extends StateNotifier<bool> {
  final NotificationApi _notificationApi;
  NotificationController({
    required NotificationApi notificationApi,
  })  : _notificationApi = notificationApi,
        super(false);

  void createNotification({
    required String text,
    required String postId,
    required NotificationType notificationType,
    required String uid,
  }) async {
    final notification = Notifications(
      text: text,
      postId: postId,
      id: '',
      uid: uid,
      notificationType: notificationType,
    );

    final res = await _notificationApi.createNotification(notification);
    res.fold((l) => null, (r) => null);
  }

  Future<List<Notifications>> getNotifications(String uid) async {
    final notifications = await _notificationApi.getNotifications(uid);
    return notifications
        .map(
          (e) => Notifications.fromMap(e.data),
        )
        .toList();
  }
}
