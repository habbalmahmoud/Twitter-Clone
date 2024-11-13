import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter__clone/core/providers.dart';
import 'package:twitter__clone/models/tweet_model.dart';

import '../constants/constants.dart';
import '../core/core.dart';

final tweetAPIProvider = Provider((ref) {
  return TweetApi(
      db: ref.watch(
    appwriteDatabaseProvider,
  ));
});

abstract class ITweetAPI {
  FutureEither<Document> shareTweet(Tweet tweet);
}

class TweetApi implements ITweetAPI {
  final Databases _db;
  TweetApi({required Databases db}) : _db = db;

  @override
  FutureEither<Document> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollectionId,
        documentId: ID.unique(),
        data: tweet.toMap(),
      );
      return right(document);
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
}
