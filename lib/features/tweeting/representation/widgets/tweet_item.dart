import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/widgets/avatar.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/comment_bloc.dart';
import 'package:fc_twitter/features/tweeting/data/model/tweet_model.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/timeline/representation/pages/comments_screen.dart';
import 'package:fc_twitter/features/tweeting/representation/widgets/quoteItem.dart';
import 'package:fc_twitter/features/tweeting/representation/widgets/tweet_image_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'like_button.dart';
import 'more_options_button.dart';
import 'retweet_button.dart';

class TweetItem extends StatefulWidget {
  const TweetItem({
    Key key,
    @required TweetEntity tweet,
    @required UserProfileEntity profile,
  })  : _tweet = tweet,
        _currentUserProfile = profile,
        super(key: key);

  final TweetEntity _tweet;
  final UserProfileEntity _currentUserProfile;

  @override
  _TweetItemState createState() => _TweetItemState();
}

class _TweetItemState extends State<TweetItem> {
  Future<UserProfileEntity> _getUserProfile;
  Future<UserProfileEntity> _getRetweetersProfile;
  Future<UserProfileEntity> _getCommentto;
  Future<TweetEntity> _getQuoteto;

  @override
  void initState() {
    super.initState();
    _getUserProfile = widget._tweet.userProfile
        .get()
        .then((snapshot) => UserProfileModel.fromDoc(snapshot));
    if (widget._tweet.isRetweet) {
      _getRetweetersProfile = widget._tweet.retweetersProfile
          .get()
          .then((snapshot) => UserProfileModel.fromDoc(snapshot));
    }
    if (widget._tweet.isComment) {
      _getCommentto = widget._tweet.commentTo.get().then((value) async {
        final tweet = TweetModel.fromSnapShot(value);
        final user = await tweet.userProfile.get();
        return UserProfileModel.fromDoc(user);
      });
    }
    if (widget._tweet.isQuote) {
      _getQuoteto = widget._tweet.quoteTo
          .get()
          .then((value) => TweetModel.fromSnapShot(value));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<UserProfileEntity>(
      future: _getUserProfile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        }
        final profile = snapshot.data;
        return GestureDetector(
          onTap: () {
            context
                .read<CommentBloc>()
                .add(FetchComments(tweet: widget._tweet));
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CommentsScreen(
                        tweet: widget._tweet,
                        currentUserProfile: widget._currentUserProfile,
                      )),
            );
          },
          child: Container(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Avatar(userProfile: profile, radius: 24),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget._tweet.isRetweet)
                            FutureBuilder<UserProfileEntity>(
                                future: _getRetweetersProfile,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SizedBox.shrink();
                                  }
                                  final retweetersProfile = snapshot.data;
                                  return Row(
                                    children: [
                                      Icon(EvilIcons.retweet,
                                          size: 18, color: theme.accentColor),
                                      SizedBox(width: 5),
                                      Text(
                                        retweetersProfile?.userName ==
                                                widget._currentUserProfile
                                                    ?.userName
                                            ? 'You Retweeted'
                                            : '${retweetersProfile?.userName} Retweeted',
                                        style: TextStyle(
                                          fontSize:
                                              Config.xMargin(context, 3.2),
                                          color: theme.accentColor,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          Row(
                            children: [
                              Text(
                                profile.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Config.xMargin(context, 4.5),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                profile.userName,
                                style: TextStyle(
                                  color: theme.accentColor,
                                ),
                              ),
                              Text(' . '),
                              Text(
                                widget._tweet.getTime(widget._tweet.timeStamp),
                                style: TextStyle(
                                  color: theme.accentColor,
                                ),
                              ),
                              Spacer(),
                              MoreOptionsButton(
                                userProfile: profile,
                                currentUser: widget._currentUserProfile,
                              ),
                            ],
                          ),
                          if (widget._tweet.isComment)
                            FutureBuilder<UserProfileEntity>(
                                future: _getCommentto,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SizedBox.shrink();
                                  }
                                  final commentTo = snapshot.data;
                                  return Row(
                                    children: [
                                      Text(
                                        'Replying to ',
                                        style:
                                            TextStyle(color: theme.accentColor),
                                      ),
                                      Text(
                                        commentTo.userName,
                                        style: TextStyle(
                                            color: theme.primaryColor),
                                      ),
                                    ],
                                  );
                                }),
                          Text(widget._tweet.message),
                          if (widget._tweet.hasMedia)
                            TweetImageDisplay(tweet: widget._tweet),
                          if (widget._tweet.isQuote)
                            FutureBuilder<TweetEntity>(
                                future: _getQuoteto,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SizedBox.fromSize();
                                  }
                                  final quoteTweet = snapshot.data;
                                  return QuoteItem(
                                    tweet: quoteTweet,
                                    profile: widget._currentUserProfile,
                                  );
                                }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(EvilIcons.comment,
                                  color: theme.accentColor, size: 22),
                              SizedBox(width: 5),
                              Text(
                                '${widget._tweet.noOfComments}',
                                style: TextStyle(
                                  color: theme.accentColor,
                                ),
                              ),
                              Spacer(),
                              RetweetButton(
                                  profile: widget._currentUserProfile,
                                  tweet: widget._tweet),
                              Spacer(),
                              LikeButton(
                                  profile: widget._currentUserProfile,
                                  tweet: widget._tweet),
                              Spacer(),
                              IconButton(
                                icon: Icon(
                                  EvilIcons.share_google,
                                  color: theme.accentColor,
                                ),
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
                Divider(thickness: 1, height: 15)
              ],
            ),
          ),
        );
      },
    );
  }
}