import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter/cupertino.dart';

class TweetModel extends TweetEntity {
  TweetModel(
      {@required id,
      @required userProfile,
      @required message,
      @required timeStamp,
      retweetersProfile,
      quoteTo,
      noOfComments,
      commentTo,
      retweetTo,
      images,
      retweetedBy,
      likedBy,
      isRetweet,
      hasMedia,
      isComment})
      : super(
          id: id,
          userProfile: userProfile,
          retweetersProfile: retweetersProfile,
          message: message,
          timeStamp: timeStamp,
          quoteTo: quoteTo,
          retweetTo: retweetTo,
          commentTo: commentTo,
          noOfComments: noOfComments,
          images: images,
          retweetedBy: retweetedBy,
          likedBy: likedBy,
          isRetweet: isRetweet,
          hasMedia: hasMedia,
          isComment: isComment,
        );

  factory TweetModel.fromSnapShot(DocumentSnapshot snapShot) {
    final data = snapShot.data();
    return TweetModel(
      id: snapShot.id,
      userProfile: data['userProfile'],
      message: data['message'],
      timeStamp: data['timeStamp'],
      quoteTo: data['quoteTo'],
      retweetersProfile: data['retweetersProfile'],
      retweetTo: data['retweetTo'],
      commentTo: data['commentTo'],
      noOfComments: data['noOfComments'] ?? 0,
      images: data['images'] ?? List(),
      retweetedBy: data['retweetedBy'] ?? List(),
      likedBy: data['likedBy'] ?? List(),
      hasMedia: data['hasMedia'] ?? false,
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
      retweetTo: tweet.retweetTo,
      quoteTo: tweet.quoteTo,
      commentTo: tweet.commentTo,
      noOfComments: tweet.noOfComments,
      images: tweet.images,
      retweetedBy: tweet.retweetedBy,
      likedBy: tweet.likedBy,
      hasMedia: tweet.hasMedia,
      isRetweet: tweet.isRetweet,
      isComment: tweet.isComment,
    );
  }

  factory TweetModel.fromMap(Map<String, dynamic> data) {
    return TweetModel(
      id: data['id'],
      userProfile: data['userProfile'],
      retweetersProfile: data['retweetersProfile'],
      message: data['message'],
      timeStamp: data['timeStamp'],
      quoteTo: data['quoteTo'],
      commentTo: data['commentTo'],
      retweetTo: data['retweetTo'],
      noOfComments: data['noOfComments'] ?? 0,
      images: data['images'] ?? List(),
      retweetedBy: data['retweetedBy'] ?? List(),
      likedBy: data['likedBy'] ?? List(),
      hasMedia: data['hasMedia'] ?? false,
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
      retweetTo: this.retweetTo,
      commentTo: this.commentTo,
      noOfComments: this.noOfComments,
      images: this.images,
      retweetedBy: this.retweetedBy,
      likedBy: this.likedBy,
      hasMedia: this.hasMedia,
      isRetweet: this.isRetweet,
      isComment: this.isComment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'userProfile': this.userProfile,
      'retweetersProfile': this.retweetersProfile,
      'message': this.message,
      'timeStamp': this.timeStamp,
      'quoteTo': this.quoteTo,
      'commentTo': this.commentTo,
      'retweetTo': this.retweetTo,
      'noOfComments': this.noOfComments,
      'images': this.images,
      'retweetedBy': this.retweetedBy,
      'likedBy': this.likedBy,
      'hasMedia': this.hasMedia,
      'isRetweet': this.isRetweet,
      'isComment': this.isComment,
    };
  }
}
