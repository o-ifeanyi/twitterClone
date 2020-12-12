import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/timeline/domain/entity/tweet_entity.dart';
import 'package:flutter/cupertino.dart';

class TweetModel extends TweetEntity {
  TweetModel({
    @required name,
    @required userName,
    @required message,
    @required timeStamp,
  }) : super(
            name: name,
            userName: userName,
            message: message,
            timeStamp: timeStamp);

  factory TweetModel.fromSnapShot(snapShot) {
    return TweetModel(
      name: snapShot['name'],
      userName: snapShot['userName'],
      message: snapShot['message'],
      timeStamp: getTime(snapShot['timeStamp']),
    );
  }

  factory TweetModel.fromEntity(TweetEntity tweet) {
    return TweetModel(
      name: tweet.name,
      userName: tweet.userName,
      message: tweet.message,
      timeStamp: tweet.timeStamp,
    );
  }

  TweetEntity toEntity() {
    return TweetEntity(
      name: this.name,
      userName: this.userName,
      message: this.message,
      timeStamp: this.timeStamp,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': this.name,
      'userName': this.userName,
      'message': this.message,
      'timeStamp': this.timeStamp,
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
