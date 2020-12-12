import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/timeline/domain/entity/tweet_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class TweetItem extends StatelessWidget {
  final TweetEntity _tweet;

  TweetItem(this._tweet);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _tweet.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Config.xMargin(context, 4.5),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(_tweet.userName),
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
                    Text('12'),
                    Spacer(),
                    Icon(EvilIcons.retweet),
                    SizedBox(width: 5),
                    Text('36'),
                    Spacer(),
                    Icon(EvilIcons.heart),
                    SizedBox(width: 5),
                    Text('235'),
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