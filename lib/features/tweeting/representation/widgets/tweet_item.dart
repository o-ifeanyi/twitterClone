import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/representation/pages/comments_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'avatar.dart';
import 'like_button.dart';
import 'retweet_button.dart';

class TweetItem extends StatelessWidget {
  final TweetEntity _tweet;
  final UserProfileEntity _profile;

  TweetItem(this._tweet, this._profile);

  bool isLiked(UserProfileEntity profile, TweetEntity tweet) {
    return tweet.likedBy.any((element) => element['id'] == profile?.id);
  }

  bool isRetweeted(UserProfileEntity profile, TweetEntity tweet) {
    return tweet.retweetedBy.any((element) => element['id'] == profile?.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isTweetLiked = isLiked(_profile, _tweet);
    final bool isTweetRetweeted = isRetweeted(_profile, _tweet);
    return GestureDetector(
      onTap: () {
        final arguments = {
          'tweet': _tweet,
          'profile': _profile,
        };
        Navigator.pushNamed(context, CommentsScreen.pageId,
            arguments: arguments);
      },
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Avatar(imageUrl: _tweet.userProfile.profilePhoto, radius: 24),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_tweet.isRetweet)
                    Row(
                      children: [
                        Icon(EvilIcons.retweet, size: 18),
                        SizedBox(width: 5),
                        Text(
                          _tweet.retweetersProfile?.userName ==
                                  _profile?.userName
                              ? 'You Retweeted'
                              : '${_tweet.retweetersProfile?.userName} Retweeted',
                          style:
                              TextStyle(fontSize: Config.xMargin(context, 3.2)),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      Text(
                        _tweet.userProfile.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
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
                      Text(' . '),
                      Text(
                        _tweet.getTime(_tweet.timeStamp),
                        style: TextStyle(
                          color: theme.accentColor,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.expand_more_outlined,
                          color: theme.accentColor),
                    ],
                  ),
                  if (_tweet.isComment) Row(
                      children: [
                        Text(
                          'Replying to ',
                          style: TextStyle(color: theme.accentColor),
                        ),
                        Text(
                          _tweet.userProfile.userName,
                          style: TextStyle(color: theme.primaryColor),
                        ),
                      ],
                    ),
                  Text(_tweet.message),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(EvilIcons.comment, color: theme.accentColor),
                      SizedBox(width: 5),
                      Text(
                        '${_tweet.comments.length}',
                        style: TextStyle(
                          color: theme.accentColor,
                        ),
                      ),
                      Spacer(),
                      RetweetButton(
                          profile: _profile,
                          tweet: _tweet),
                      SizedBox(width: 5),
                      Text(
                        '${_tweet.retweetedBy.length},',
                        style: TextStyle(
                          color: isTweetRetweeted
                              ? Colors.greenAccent
                              : theme.accentColor,
                        ),
                      ),
                      Spacer(),
                      LikeButton(
                          profile: _profile,
                          tweet: _tweet),
                      SizedBox(width: 5),
                      Text('${_tweet.likedBy.length}',
                          style: TextStyle(
                            color:
                                isTweetLiked ? Colors.red : theme.accentColor,
                          )),
                      Spacer(),
                      IconButton(
                        icon: Icon(EvilIcons.share_google),
                        onPressed: () {},
                      ),
                      Spacer(),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
