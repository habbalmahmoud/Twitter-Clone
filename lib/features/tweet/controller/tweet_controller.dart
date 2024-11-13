import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter__clone/apis/tweet_api.dart';
import 'package:twitter__clone/core/enums/tweet_type_enum.dart';
import 'package:twitter__clone/core/utils.dart';
import 'package:twitter__clone/features/auth/controller/auth_contoller.dart';
import 'package:twitter__clone/models/tweet_model.dart';

final tweetControllerProvider = StateNotifierProvider<TweetController, bool>(
  (ref) {
    return TweetController(
      ref: ref,
      tweetApi: ref.watch(tweetAPIProvider),
    );
  },
);

class TweetController extends StateNotifier<bool> {
  final Ref _ref;
  final TweetApi _tweetApi;
  TweetController({
    required Ref ref,
    required TweetApi tweetApi,
  })  : _ref = ref,
        _tweetApi = tweetApi,
        super(false);

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter text');
      return;
    }

    if (images.isNotEmpty) {
      _shareImageTweet(
        images: images,
        text: text,
        context: context,
      );
    } else {
      _shareTextTweet(
        text: text,
        context: context,
      );
    }
  }

  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {}

  void _shareTextTweet({
    required String text,
    required BuildContext context,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.watch(currentUserDetailsProvider).value!;

    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
    );
    final res = await _tweetApi.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  String _getLinkFromText(String text) {
    List<String> wordsInSentence = text.split(' ');
    String link = '';
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> wordsInSentence = text.split(' ');
    List<String> hashtags = [];
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }
}
