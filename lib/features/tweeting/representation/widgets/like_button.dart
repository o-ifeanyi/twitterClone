import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/representation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({
    Key key,
    @required UserProfileEntity profile,
    @required this.isTweetLiked,
    @required TweetEntity tweet,
  })  : _profile = profile,
        _tweet = tweet,
        super(key: key);

  final UserProfileEntity _profile;
  final bool isTweetLiked;
  final TweetEntity _tweet;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_profile == null) return;
        context.read<TweetingBloc>().add(
              isTweetLiked
                  ? UnlikeTweet(
                      userProfile: _profile,
                      tweet: _tweet,
                    )
                  : LikeTweet(
                      userProfile: _profile,
                      tweet: _tweet,
                    ),
            );
      },
      child: Icon(
        isTweetLiked
            ? MaterialCommunityIcons.heart
            : MaterialCommunityIcons.heart_outline,
        size: 18,
        color: isTweetLiked ? Colors.red : Theme.of(context).accentColor,
      ),
    );
  }
}