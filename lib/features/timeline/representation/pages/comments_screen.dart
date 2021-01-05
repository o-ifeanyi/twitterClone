import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/timeline/representation/widgets/comment_builder.dart';
import 'package:fc_twitter/features/timeline/representation/widgets/comment_item.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/representation/bloc/bloc.dart';
import 'package:fc_twitter/features/tweeting/representation/widgets/like_button.dart';
import 'package:fc_twitter/features/tweeting/representation/widgets/retweet_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CommentsScreen extends StatefulWidget {
  static const String pageId = '/commentsScreen';

  CommentsScreen({
    TweetEntity tweet,
    UserProfileEntity currentUserProfile,
  })  : _tweet = tweet,
        _currentUserProfile = currentUserProfile;

  final TweetEntity _tweet;
  final UserProfileEntity _currentUserProfile;
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  Future<UserProfileEntity> _getUserProfile;

  final _replyController = TextEditingController();
  final _replyNode = FocusNode();

  void sendReply(UserProfileEntity profile, TweetEntity tweet) {
    if (_replyController.text.isEmpty) return;
    context.read<TweetingBloc>().add(
          Comment(
            tweet: tweet,
            userProfile: profile,
            comment: TweetEntity(
              id: tweet.id,
              message: _replyController.text,
              isComment: true,
              timeStamp: Timestamp.now(),
            ),
          ),
        );
    _replyController.clear();
    _replyNode.unfocus();
  }

  @override
  void initState() {
    super.initState();
    _getUserProfile = widget._tweet.userProfile
          .get()
          .then((snapshot) => UserProfileModel.fromDoc(snapshot));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isTyping = _replyNode.hasFocus;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tweet',
          style: TextStyle(color: theme.textTheme.headline6.color),
        ),
      ),
      body: FutureBuilder<UserProfileEntity>(
          future: _getUserProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox.shrink();
            }
            final _tweetProfile = snapshot.data;
            return Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.only(
                      bottom: Config.yMargin(
                          context, _replyNode.hasFocus ? 15 : 7)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CommentItem(
                          tweet: widget._tweet,
                          profile: widget._currentUserProfile,
                          tweetProfile: _tweetProfile,
                        ),
                        Divider(thickness: 2, height: 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(EvilIcons.comment,
                                color: theme.accentColor, size: 22),
                            RetweetButton(
                              profile: widget._currentUserProfile,
                              tweet: widget._tweet,
                            ),
                            LikeButton(
                              profile: widget._currentUserProfile,
                              tweet: widget._tweet,
                            ),
                            IconButton(
                              icon: Icon(EvilIcons.share_google),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        Divider(thickness: 2, height: 0),
                        CommentBuilder(),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isTyping)
                          Row(
                            children: [
                              Text(
                                'Replying to ',
                                style: TextStyle(color: theme.accentColor),
                              ),
                              Text(
                                _tweetProfile.userName,
                                style: TextStyle(color: theme.primaryColor),
                              ),
                            ],
                          ),
                        TextField(
                          controller: _replyController,
                          focusNode: _replyNode,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            hintText: 'Tweet your reply',
                          ),
                        ),
                        SizedBox(height: 5),
                        if (isTyping)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                AntDesign.picture,
                                size: 32,
                                color: theme.primaryColor,
                              ),
                              GestureDetector(
                                onTap: () =>
                                    sendReply(widget._currentUserProfile, widget._tweet),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  width: Config.xMargin(context, 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: theme.primaryColor,
                                  ),
                                  child: Text(
                                    'Reply',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: Config.xMargin(context, 4)),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
