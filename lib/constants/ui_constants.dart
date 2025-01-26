// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter__clone/constants/assets_constants.dart';
import 'package:twitter__clone/features/explore/view/explore_view.dart';
import 'package:twitter__clone/features/notifications/view/notification_view.dart';
import 'package:twitter__clone/features/tweet/widgets/tweet_list.dart';
import 'package:twitter__clone/theme/pallete.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        color: Pallete.blueColor,
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static List<Widget> bottomTapBarPages = [
    TweetList(),
    ExploreView(),
    NotificationView(),
  ];
}
