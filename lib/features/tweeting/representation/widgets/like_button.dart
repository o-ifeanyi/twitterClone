import 'package:cloud_firestore/cloud_firestore.dart';
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
    @required TweetEntity tweet,
  })  : _profile = profile,
        _tweet = tweet,
        super(key: key);

  final UserProfileEntity _profile;
  final TweetEntity _tweet;

  bool isLiked() {
    if (_tweet == null || _profile == null) return false;
    return _tweet.likedBy.any((element) => (element as DocumentReference).path.endsWith(_profile?.id));
  }

  @override
  Widget build(BuildContext context) {
    bool isTweetLiked = isLiked();
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isTweetLiked
                ? MaterialCommunityIcons.heart
                : MaterialCommunityIcons.heart_outline,
            size: 18,
            color: isTweetLiked ? Colors.red : Theme.of(context).accentColor,
          ),
          SizedBox(width: 5),
          Text(
            '${_tweet.likedBy.length}',
            style: TextStyle(
              color: isTweetLiked ? Colors.red : Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
