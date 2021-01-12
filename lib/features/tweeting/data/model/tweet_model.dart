import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter/cupertino.dart';

class TweetModel extends TweetEntity {
  TweetModel(
      {@required id,
      @required userProfile,
      @required message,
      @required timeStamp,
      userId,
      retweetersProfile,
      quoteTo,
      noOfComments,
      commentTo,
      retweetTo,
      images,
      retweetedBy,
      likedBy,
      quotedBy,
      isQuote,
      isRetweet,
      hasMedia,
      isComment})
      : super(
          id: id,
          userId: userId,
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
          quotedBy: quotedBy,
          isQuote: isQuote,
          isRetweet: isRetweet,
          hasMedia: hasMedia,
          isComment: isComment,
        );

  factory TweetModel.fromSnapShot(DocumentSnapshot snapShot) {
    final data = snapShot.data();
    return TweetModel(
      id: snapShot.id,
      userId: data['userId'],
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
      quotedBy: data['quotedBy'] ?? List(),
      likedBy: data['likedBy'] ?? List(),
      isQuote: data['isQuote'] ?? false,
      hasMedia: data['hasMedia'] ?? false,
      isRetweet: data['isRetweet'] ?? false,
      isComment: data['isComment'] ?? false,
    );
  }

  factory TweetModel.fromEntity(TweetEntity tweet) {
    return TweetModel(
      id: tweet.id,
      userId: tweet.userId,
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
      quotedBy: tweet.quotedBy,
      likedBy: tweet.likedBy,
      isQuote: tweet.isQuote,
      hasMedia: tweet.hasMedia,
      isRetweet: tweet.isRetweet,
      isComment: tweet.isComment,
    );
  }

  TweetEntity toEntity() {
    return TweetEntity(
      id: this.id,
      userId: this.userId,
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
      quotedBy: this.quotedBy,
      likedBy: this.likedBy,
      isQuote: this.isQuote,
      hasMedia: this.hasMedia,
      isRetweet: this.isRetweet,
      isComment: this.isComment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'userId': this.userId,
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
      'quotedBy': this.quotedBy,
      'likedBy': this.likedBy,
      'isQuote': this.isQuote,
      'hasMedia': this.hasMedia,
      'isRetweet': this.isRetweet,
      'isComment': this.isComment,
    };
  }
}
