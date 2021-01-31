import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/tweeting/representation/pages/tweet_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/representation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class RetweetButton extends StatelessWidget {
  const RetweetButton({
    Key key,
    @required UserProfileEntity profile,
    @required TweetEntity tweet,
  })  : _profile = profile,
        _tweet = tweet,
        super(key: key);

  final UserProfileEntity _profile;
  final TweetEntity _tweet;

  GestureDetector _button(
      {BuildContext context, Function onPressed, String label, Icon icon}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            icon,
            SizedBox(width: 10),
            Text(label),
          ],
        ),
      ),
    );
  }

  bool isRetweeted() {
    if (_tweet == null || _profile == null) return false;
    return _tweet.retweetedBy.any(
        (element) => element.path.endsWith(_profile.id));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isTweetRetweeted = isRetweeted();
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            alignment: Alignment.centerLeft,
            height: Config.yMargin(context, isTweetRetweeted ? 7 : 14),
            child: isTweetRetweeted
                ? _button(
                    context: context,
                    onPressed: () {
                      if (_profile == null) return;
                      context.read<TweetingBloc>().add(UndoRetweet(
                            userProfile: _profile,
                            tweet: _tweet,
                          ));
                      Navigator.pop(context);
                    },
                    label: 'Undo Retweet',
                    icon: Icon(EvilIcons.retweet, size: 30, color: theme.accentColor),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _button(
                        context: context,
                        onPressed: () {
                          if (_profile == null) return;
                          context.read<TweetingBloc>().add(
                                Retweet(
                                  userProfile: _profile,
                                  tweet: _tweet,
                                ),
                              );
                          Navigator.pop(context);
                        },
                        label: 'Retweet',
                        icon: Icon(EvilIcons.retweet, size: 30, color: theme.accentColor),
                      ),
                      _button(
                        context: context,
                        onPressed: () {
                          print('hi');
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TweetScreen(quoteTweet: _tweet),
                            ),
                          );
                        },
                        label: 'Quote Tweet',
                        icon: Icon(Feather.edit_2, color: theme.accentColor),
                      ),
                    ],
                  ),
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isTweetRetweeted
                ? MaterialCommunityIcons.twitter_retweet
                : EvilIcons.retweet,
            color: isTweetRetweeted
                ? Colors.greenAccent
                : Theme.of(context).accentColor,
          ),
          SizedBox(width: 5),
          Text(
            '${_tweet.retweetedBy.length + _tweet.quotedBy.length},',
            style: TextStyle(
              color: isTweetRetweeted
                  ? Colors.greenAccent
                  : Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
