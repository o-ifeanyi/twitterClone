import 'dart:io';

import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/widgets/avatar.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/representation/widgets/tweet_image_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CommentItem extends StatefulWidget {
  const CommentItem({
    Key key,
    @required TweetEntity tweet,
    @required UserProfileEntity tweetProfile,
    @required UserProfileEntity profile,
  })  : _tweet = tweet,
        _currentUserProfile = profile,
        _tweetProfile = tweetProfile,
        super(key: key);

  final TweetEntity _tweet;
  final UserProfileEntity _tweetProfile;
  final UserProfileEntity _currentUserProfile;

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  Future<UserProfileEntity> _getRetweetersProfile;

  @override
  void initState() {
    super.initState();
    if (widget._tweet.isRetweet) {
      _getRetweetersProfile = widget._tweet.retweetersProfile
          .get()
          .then((snapshot) => UserProfileModel.fromDoc(snapshot));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAndroid = Platform.isAndroid;
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget._tweet.isRetweet)
            Padding(
              padding: EdgeInsets.only(left: Config.xMargin(context, 10)),
              child: FutureBuilder<UserProfileEntity>(
                  future: _getRetweetersProfile,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox.shrink();
                    }
                    final retweetersProfile = snapshot.data;
                    print(retweetersProfile.userName);
                    return Row(
                      children: [
                        Icon(EvilIcons.retweet,
                            size: 18, color: theme.accentColor),
                        SizedBox(width: 5),
                        Text(
                          retweetersProfile?.userName ==
                                  widget._currentUserProfile?.userName
                              ? 'You Retweeted'
                              : '${retweetersProfile?.userName} Retweeted',
                          style: TextStyle(
                            fontSize: Config.xMargin(context, 3.2),
                            color: theme.accentColor,
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          SizedBox(height: 5),
          Row(
            children: [
              Avatar(userProfile: widget._tweetProfile, radius: 28),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget._tweetProfile.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Config.xMargin(context, 4.5),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    widget._tweetProfile.userName,
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
            widget._tweet.message,
            style: TextStyle(fontSize: Config.xMargin(context, 5)),
          ),
          if (widget._tweet.hasMedia) TweetImageDisplay(tweet: widget._tweet),
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
          if (widget._tweet.retweetedBy.isNotEmpty ||
              widget._tweet.likedBy.isNotEmpty)
            SizedBox(
              height: 10,
            ),
          Column(
            children: [
              Row(
                children: [
                  if (widget._tweet.retweetedBy.isNotEmpty) ...[
                    Text('${widget._tweet.retweetedBy.length}'),
                    Text(
                      ' Retweet',
                      style: TextStyle(
                        color: theme.accentColor,
                      ),
                    ),
                    SizedBox(width: 15),
                  ],
                  if (widget._tweet.likedBy.isNotEmpty) ...[
                    Text('${widget._tweet.likedBy.length}'),
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
            ],
          ),
        ],
      ),
    );
  }
}
