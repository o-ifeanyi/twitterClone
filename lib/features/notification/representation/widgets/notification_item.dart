import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/notification/domain/entity/notification_entity.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/widgets/avatar.dart';
import 'package:fc_twitter/features/tweeting/data/model/tweet_model.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatefulWidget {
  final NotificationEntity notification;

  NotificationItem({this.notification});
  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  Future<TweetEntity> _getTweet;
  Future<UserProfileEntity> _getUserProfile;

  @override
  void initState() {
    super.initState();
    _getTweet = widget.notification.tweet
        .get()
        .then((value) => TweetModel.fromSnapShot(value));
    _getUserProfile = widget.notification.userProfile
        .get()
        .then((value) => UserProfileModel.fromDoc(value));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: widget.notification.isSeen
                ? theme.scaffoldBackgroundColor
                : theme.primaryColor.withOpacity(0.2),
          ),
          child: FutureBuilder<TweetEntity>(
            future: _getTweet,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(height: 20);
              }

              final tweet = snapshot.data;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: Config.xMargin(context, 4)),
                    child: Icon(Icons.favorite, color: Colors.red),
                  ),
                  SizedBox(width: 10),
                  FutureBuilder<UserProfileEntity>(
                    future: _getUserProfile,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox.shrink();
                      }

                      final profile = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Avatar(userProfile: profile, radius: 15),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                profile.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Config.xMargin(context, 4.2),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text('liked your Tweet')
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            tweet.message,
                            style: TextStyle(
                              color: theme.accentColor,
                            ),
                          ),
                        ],
                      );
                    },
                  )
                ],
              );
            },
          ),
        ),
        Divider(thickness: 1, height: 0)
      ],
    );
  }
}
