import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter__clone/constants/appwrite_constants.dart';
import 'package:twitter__clone/core/failure.dart';
import 'package:twitter__clone/core/providers.dart';
import 'package:twitter__clone/core/type_defs.dart';
import 'package:twitter__clone/models/notification_model.dart';

final notificationAPIProvider = Provider((ref) {
  return NotificationApi(
    db: ref.watch(
      appwriteDatabaseProvider,
    ),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class INotificationAPI {
  FutureEitherVoid createNotification(Notifications notification);
  Future<List<Document>> getNotifications(String uid);
  Stream<RealtimeMessage> getLatestNotification();
}

class NotificationApi implements INotificationAPI {
  final Databases _db;
  final Realtime _realtime;
  NotificationApi({
    required Databases db,
    required Realtime realtime,
  })  : _realtime = realtime,
        _db = db;

  @override
  FutureEitherVoid createNotification(Notifications notification) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.notificationsCollectionId,
        documentId: ID.unique(),
        data: notification.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.toString(),
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getNotifications(String uid) async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.notificationsCollectionId,
        queries: [
          Query.equal('uid', uid),
        ]);
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestNotification() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.notificationsCollectionId}.documents'
    ]).stream;
  }
}
