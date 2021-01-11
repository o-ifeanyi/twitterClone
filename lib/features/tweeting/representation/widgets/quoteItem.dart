import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/widgets/avatar.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/comment_bloc.dart';
import 'package:fc_twitter/features/tweeting/data/model/tweet_model.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/timeline/representation/pages/comments_screen.dart';
import 'package:fc_twitter/features/tweeting/representation/widgets/tweet_image_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuoteItem extends StatefulWidget {
  const QuoteItem({
    Key key,
    @required TweetEntity tweet,
    @required UserProfileEntity profile,
  })  : _tweet = tweet,
        _currentUserProfile = profile,
        super(key: key);

  final TweetEntity _tweet;
  final UserProfileEntity _currentUserProfile;

  @override
  _QuoteItemState createState() => _QuoteItemState();
}

class _QuoteItemState extends State<QuoteItem> {
  Future<UserProfileEntity> _getUserProfile;
  Future<UserProfileEntity> _getCommentto;

  @override
  void initState() {
    super.initState();
    _getUserProfile = widget._tweet.userProfile
        .get()
        .then((snapshot) => UserProfileModel.fromDoc(snapshot));
    if (widget._tweet.isComment) {
      _getCommentto = widget._tweet.commentTo.get().then((value) async {
        final tweet = TweetModel.fromSnapShot(value);
        final user = await tweet.userProfile.get();
        return UserProfileModel.fromDoc(user);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<UserProfileEntity>(
      future: _getUserProfile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  backgroundColor: theme.primaryColor,
                ),
              ),
            ),
          );
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
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.accentColor, width: 0.3),
              color: theme.scaffoldBackgroundColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Avatar(userProfile: profile, radius: 12),
                      SizedBox(width: 10),
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
                    ],
                  ),
                ),
                if (widget._tweet.isComment)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                    child: FutureBuilder<UserProfileEntity>(
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
                                style: TextStyle(color: theme.accentColor),
                              ),
                              Text(
                                commentTo.userName,
                                style: TextStyle(color: theme.accentColor),
                              ),
                            ],
                          );
                        }),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Text(widget._tweet.message),
                ),
                if (widget._tweet.hasMedia)
                  TweetImageDisplay(
                    tweet: widget._tweet,
                    isQuote: true,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
