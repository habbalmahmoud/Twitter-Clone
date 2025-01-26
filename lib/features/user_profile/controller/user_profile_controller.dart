import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter__clone/apis/storage_api.dart';
import 'package:twitter__clone/apis/tweet_api.dart';
import 'package:twitter__clone/apis/user_api.dart';
import 'package:twitter__clone/core/enums/notification_type_enum.dart';
import 'package:twitter__clone/core/utils.dart';
import 'package:twitter__clone/features/notifications/controller/notification_controller.dart';
import 'package:twitter__clone/models/tweet_model.dart';
import 'package:twitter__clone/models/user_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    tweetApi: ref.watch(tweetAPIProvider),
    storageApi: ref.watch(storageApiProvider),
    userApi: ref.watch(userApiProvider),
    notificationController: ref.watch(notificationControllerProvider.notifier),
  );
});

final getUserTweetsProvider = FutureProvider.family((ref, String uid) async {
  final userProfileController =
      ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getUserTweets(uid);
});

final getLatestUserProfileDataProvider = StreamProvider((ref) {
  final userApi = ref.watch(userApiProvider);
  return userApi.getLatestUserProfileData();
});

class UserProfileController extends StateNotifier<bool> {
  final TweetApi _tweetApi;
  final StorageApi _storageApi;
  final UserApi _userApi;
  final NotificationController _notificationController;
  UserProfileController({
    required TweetApi tweetApi,
    required StorageApi storageApi,
    required UserApi userApi,
    required NotificationController notificationController,
  })  : _tweetApi = tweetApi,
        _storageApi = storageApi,
        _userApi = userApi,
        _notificationController = notificationController,
        super(false);

  Future<List<Tweet>> getUserTweets(String uid) async {
    final tweets = await _tweetApi.getUserTweets(uid);
    return tweets.map((user) => Tweet.fromMap(user.data)).toList();
  }

  void updateUserData({
    required UserModel userModel,
    required BuildContext context,
    required File? bannerFile,
    required File? profileFile,
  }) async {
    state = true;
    if (bannerFile != null) {
      final bannerUrl = await _storageApi.uploadImage([bannerFile]);
      userModel = userModel.copyWith(
        bannerPic: bannerUrl[0],
      );
    }

    if (profileFile != null) {
      final profileUrl = await _storageApi.uploadImage([profileFile]);
      userModel = userModel.copyWith(
        profilePic: profileUrl[0],
      );
    }

    final res = await _userApi.updateUserData(userModel);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Navigator.pop(context),
    );
  }

  void followUser({
    required UserModel user,
    required BuildContext context,
    required UserModel currentUser,
  }) async {
    if (currentUser.following.contains(user.uid)) {
      user.followers.remove(currentUser.uid);
      currentUser.following.remove(user.uid);
    } else {
      user.followers.add(currentUser.uid);
      currentUser.following.add(user.uid);
    }

    user = user.copyWith(followers: user.followers);
    currentUser = currentUser.copyWith(following: currentUser.following);

    final res = await _userApi.followUser(user);
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      final res2 = await _userApi.addToFollowing(currentUser);
      res2.fold((l) => showSnackBar(context, l.message), (r) {
        _notificationController.createNotification(
          text: '${currentUser.name} followed you!',
          postId: '',
          notificationType: NotificationType.follow,
          uid: user.uid,
        );
      });
    });
  }
}
