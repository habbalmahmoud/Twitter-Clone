class AppwriteConstants {
  static const String databaseId = '672f639c001ebe6f6177';
  static const String projectId = '672f628100173257d13f';
  static const String endPoint = 'https://cloud.appwrite.io/v1';

  static const String usersCollectionId = '672f63ba001ae252ba83';
  static const String tweetsCollectionId = '6734cb71001008f2146f';
  static const String notificationsCollectionId = '6775f8fd001c1b4d3783';

  static const String imagesBucketId = '673a0049002dad258a2a';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucketId/files/$imageId/view?project=$projectId&mode=admin';
}
