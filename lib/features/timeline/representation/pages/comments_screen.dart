import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/comment_bloc.dart';
import 'package:fc_twitter/features/timeline/representation/widgets/comment_item.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/representation/bloc/bloc.dart';
import 'package:fc_twitter/features/tweeting/representation/widgets/like_button.dart';
import 'package:fc_twitter/features/tweeting/representation/widgets/retweet_button.dart';
import 'package:fc_twitter/features/tweeting/representation/widgets/tweet_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CommentsScreen extends StatefulWidget {
  static const String pageId = '/commentsScreen';
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _replyController = TextEditingController();
  final _replyNode = FocusNode();

  void sendReply(UserProfileEntity profile, TweetEntity tweet) {
    if (_replyController.text.isEmpty) return;
    context.read<TweetingBloc>().add(
          Comment(
            tweet: tweet,
            comment: TweetEntity(
              id: null,
              userProfile: profile,
              message: _replyController.text,
              isComment: true,
              commentingTo: tweet.id,
              timeStamp: Timestamp.now(),
            ),
          ),
        );
    _replyController.clear();
    _replyNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    final TweetEntity _tweet = arguments['tweet'];
    final UserProfileEntity _profile = arguments['profile'];
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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            // color: Colors.blue,
            margin: EdgeInsets.only(
                bottom: Config.yMargin(context, _replyNode.hasFocus ? 15 : 7)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CommentItem(tweet: _tweet, profile: _profile),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(EvilIcons.comment),
                      RetweetButton(
                        profile: _profile,
                        tweet: _tweet,
                      ),
                      LikeButton(
                        profile: _profile,
                        tweet: _tweet,
                      ),
                      IconButton(
                        icon: Icon(EvilIcons.share_google),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Divider(thickness: 2, height: 0),
                  CommentBuilder(tweet: _tweet),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                          _tweet.userProfile.userName,
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
                          onTap: () => sendReply(_profile, _tweet),
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
      ),
    );
  }
}

class CommentBuilder extends StatelessWidget {
  const CommentBuilder({
    Key key,
    @required TweetEntity tweet,
  }) : _tweet = tweet, super(key: key);

  final TweetEntity _tweet;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is FetchingComments) {
          return CircularProgressIndicator();
        }
        if (state is FetchingCommentsComplete) {
          return StreamBuilder<List<TweetEntity>>(
            stream: state.commentStream,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ?
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: snapshot.data.map((e) => TweetItem(
                          tweet: e,
                          profile: e.userProfile,
                          commenTweet: _tweet,
                        ),).toList(),
                    ),
                  )
                  : Center(child: Text('nothing'));
            },
          );
        }
        return SizedBox();
      },
    );
  }
}
