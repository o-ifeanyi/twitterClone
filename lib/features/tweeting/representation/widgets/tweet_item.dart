import 'package:cached_network_image/cached_network_image.dart';
import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class TweetItem extends StatelessWidget {
  final TweetEntity _tweet;

  TweetItem(this._tweet);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: _tweet.userProfile.profilePhoto,
            imageBuilder: (_, imageProvider) => CircleAvatar(
              radius: 24,
              backgroundColor: theme.accentColor,
              backgroundImage: imageProvider,
            ),
            placeholder: (_, __) => CircleAvatar(
              radius: 24,
              backgroundColor: theme.accentColor,
              child: Icon(Icons.person, size: Config.xMargin(context, 10)),
            ),
            fit: BoxFit.contain,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _tweet.userProfile.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Config.xMargin(context, 4.5),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(_tweet.userProfile.userName),
                    Text(' . '),
                    Text(_tweet.timeStamp),
                    Spacer(),
                    Icon(Icons.expand_more_outlined),
                  ],
                ),
                Text(
                  _tweet.message,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(EvilIcons.comment),
                    SizedBox(width: 5),
                    Text('${_tweet.comments.length}'),
                    Spacer(),
                    Icon(EvilIcons.retweet),
                    SizedBox(width: 5),
                    Text('${_tweet.retweetedBy.length}'),
                    Spacer(),
                    Icon(EvilIcons.heart),
                    SizedBox(width: 5),
                    Text('${_tweet.likedBy.length}'),
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
    );
  }
}
