import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter/cupertino.dart';

class TweetModel extends TweetEntity {
  TweetModel({
    @required id,
    @required userProfile,
    @required message,
    @required timeStamp,
    retweetersProfile,
    quoteTo,
    noOfComments,
    commentingTo,
    retweetedBy,
    likedBy,
    isRetweet,
    isComment
  }) : super(
          id: id,
          userProfile: userProfile,
          retweetersProfile: retweetersProfile,
          message: message,
          timeStamp: timeStamp,
          quoteTo: quoteTo,
          commentingTo: commentingTo,
          noOfComments: noOfComments,
          retweetedBy: retweetedBy,
          likedBy: likedBy,
          isRetweet: isRetweet,
          isComment: isComment,
        );

  factory TweetModel.fromSnapShot(DocumentSnapshot snapShot) {
    final data = snapShot.data();
    final profile = UserProfileModel.fromMap(data['userProfile']).toEntity();
    final retweetersProfile = data['retweetersProfile'] != null
        ? UserProfileModel.fromMap(data['retweetersProfile']).toEntity()
        : null;
    print(data['titmeStamp']);
    return TweetModel(
      id: snapShot.id,
      userProfile: profile,
      message: data['message'],
      timeStamp: data['timeStamp'],
      quoteTo: data['quoteTo'],
      retweetersProfile: retweetersProfile,
      commentingTo: data['commentingTo'] ?? '',
      noOfComments: data['noOfComments'] ?? 0,
      retweetedBy: data['retweetedBy'] ?? List(),
      likedBy: data['likedBy'] ?? List(),
      isRetweet: data['isRetweet'] ?? false,
      isComment: data['isComment'] ?? false,
    );
  }

  factory TweetModel.fromEntity(TweetEntity tweet) {
    return TweetModel(
      id: tweet.id,
      userProfile: tweet.userProfile,
      retweetersProfile: tweet.retweetersProfile,
      message: tweet.message,
      timeStamp: tweet.timeStamp,
      quoteTo: tweet.quoteTo,
      commentingTo: tweet.commentingTo,
      noOfComments: tweet.noOfComments,
      retweetedBy: tweet.retweetedBy,
      likedBy: tweet.likedBy,
      isRetweet: tweet.isRetweet,
      isComment: tweet.isComment,
    );
  }

  factory TweetModel.fromMap(Map<String, dynamic> data) {
    final retweetersProfile = data['retweetersProfile'] != null
        ? UserProfileModel.fromMap(data['retweetersProfile']).toEntity()
        : null;
    return TweetModel(
      id: data['id'],
      userProfile: UserProfileModel.fromMap(data['userProfile']),
      retweetersProfile: retweetersProfile,
      message: data['message'],
      timeStamp: data['timeStamp'],
      quoteTo: data['quoteTo'],
      commentingTo: data['commentingTo'] ?? '',
      noOfComments: data['noOfComments'] ?? 0,
      retweetedBy: data['retweetedBy'] ?? List(),
      likedBy: data['likedBy'] ?? List(),
      isRetweet: data['isRetweet'] ?? false,
      isComment: data['isComment'] ?? false,
    );
  }

  TweetEntity toEntity() {
    return TweetEntity(
      id: this.id,
      userProfile: this.userProfile,
      retweetersProfile: this.retweetersProfile,
      message: this.message,
      timeStamp: this.timeStamp,
      quoteTo: this.quoteTo,
      commentingTo: this.commentingTo,
      noOfComments: this.noOfComments,
      retweetedBy: this.retweetedBy,
      likedBy: this.likedBy,
      isRetweet: this.isRetweet,
      isComment: this.isComment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userProfile': UserProfileModel.fromEntity(this.userProfile).toMap(),
      'retweetersProfile': this.retweetersProfile != null ?
          UserProfileModel.fromEntity(this.retweetersProfile).toMap() : null,
      'message': this.message,
      'timeStamp': this.timeStamp,
      'quoteTo': this.quoteTo,
      'commentingTo': this.commentingTo,
      'noOfComments': this.noOfComments,
      'retweetedBy': this.retweetedBy,
      'likedBy': this.likedBy,
      'isRetweet': this.isRetweet,
      'isComment': this.isComment,
    };
  }
}
