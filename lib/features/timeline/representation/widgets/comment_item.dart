import 'dart:io';

import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/widgets/avatar.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({
    Key key,
    @required TweetEntity tweet,
    @required UserProfileEntity profile,
  })  : _tweet = tweet,
        _profile = profile,
        super(key: key);

  final TweetEntity _tweet;
  final UserProfileEntity _profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAndroid = Platform.isAndroid;
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_tweet.isRetweet)
            Padding(
              padding: EdgeInsets.only(left: Config.xMargin(context, 10)),
              child: Row(
                children: [
                  Icon(EvilIcons.retweet, size: 18, color: theme.accentColor),
                  SizedBox(width: 5),
                  Text(
                    _tweet.retweetersProfile?.userName == _profile?.userName
                        ? 'You Retweeted'
                        : '${_tweet.retweetersProfile?.userName} Retweeted',
                    style: TextStyle(
                      fontSize: Config.xMargin(context, 3.2),
                      color: theme.accentColor,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 5),
          Row(
            children: [
              Avatar(userProfile: _tweet.userProfile, radius: 28),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _tweet.userProfile.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Config.xMargin(context, 4.5),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    _tweet.userProfile.userName,
                    style: TextStyle(
                      color: theme.accentColor,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.expand_more_outlined,
                color: theme.accentColor,
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            _tweet.message,
            style: TextStyle(fontSize: Config.xMargin(context, 5)),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Text(
                '9:09 - 04 Dec 20.',
                style: TextStyle(color: theme.accentColor),
              ),
              Text(
                isAndroid ? 'Twitter for Android' : 'Twitter for IOS',
                style: TextStyle(
                  color: theme.primaryColor,
                ),
              )
            ],
          ),
          if (_tweet.retweetedBy.isNotEmpty || _tweet.likedBy.isNotEmpty)
            Column(
              children: [
                Divider(thickness: 2, height: 25),
                Row(
                  children: [
                    if (_tweet.retweetedBy.isNotEmpty) ...[
                      Text('${_tweet.retweetedBy.length}'),
                      Text(
                        ' Retweet',
                        style: TextStyle(
                          color: theme.accentColor,
                        ),
                      ),
                    ],
                    SizedBox(width: 15),
                    if (_tweet.likedBy.isNotEmpty) ...[
                      Text('${_tweet.likedBy.length}'),
                      Text(
                        ' Like',
                        style: TextStyle(
                          color: theme.accentColor,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 15),
                Divider(thickness: 2, height: 0),
              ],
            ),
        ],
      ),
    );
  }
}
