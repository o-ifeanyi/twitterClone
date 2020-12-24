import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter/cupertino.dart';

class TweetModel extends TweetEntity {
  TweetModel({
    @required userProfile,
    @required message,
    @required timeStamp,
    quoteTo,
    comments,
    retweetedBy,
    likedBy,
    isRetweet,
  }) : super(
          userProfile: userProfile,
          message: message,
          timeStamp: timeStamp,
          quoteTo: quoteTo,
          comments: comments,
          retweetedBy: retweetedBy,
          likedBy: likedBy,
          isRetweet: isRetweet,
        );

  factory TweetModel.fromSnapShot(snapShot) {
    final profile = UserProfileModel.fromMap(snapShot['userProfile']).toEntity();
    return TweetModel(
      userProfile: profile,
      message: snapShot['message'],
      timeStamp: getTime(snapShot['timeStamp']),
      quoteTo: snapShot['quoteTo'],
      comments: snapShot['comments'] ?? <Map<String, dynamic>>[],
      retweetedBy: snapShot['retweetedBy'] ?? <Map<String, dynamic>>[],
      likedBy: snapShot['likedBy'] ?? <Map<String, dynamic>>[],
      isRetweet: snapShot['isRetweet']  ?? false,
    );
  }

  factory TweetModel.fromEntity(TweetEntity tweet) {
    return TweetModel(
      userProfile: tweet.userProfile,
      message: tweet.message,
      timeStamp: tweet.timeStamp,
      quoteTo: tweet.quoteTo,
      comments: tweet.comments,
      retweetedBy: tweet.retweetedBy,
      likedBy: tweet.likedBy,
      isRetweet: tweet.isRetweet,
    );
  }

  TweetEntity toEntity() {
    return TweetEntity(
      userProfile: this.userProfile,
      message: this.message,
      timeStamp: this.timeStamp,
      quoteTo: this.quoteTo,
      comments: this.comments,
      retweetedBy: this.retweetedBy,
      likedBy: this.likedBy,
      isRetweet: this.isRetweet,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'userProfile': UserProfileModel.fromEntity(this.userProfile).toMap(),
      'message': this.message,
      'timeStamp': this.timeStamp,
      'quoteTo': this.quoteTo,
      'comments': this.comments,
      'retweetedBy': this.retweetedBy,
      'likedBy': this.likedBy,
      'isRetweet': this.isRetweet,
    };
  }

  static String getTime(Timestamp timeStamp) {
    final time = DateTime.now().subtract(Duration(seconds: timeStamp.seconds));
    if (time.day > 1) {
      return '${time.day}d';
    } else if (time.hour > 1) {
      return '${time.hour}h';
    } else if (time.minute >= 1) {
      return '${time.minute}m';
    } else {
      return '${time.second}s';
    }
  }
}
