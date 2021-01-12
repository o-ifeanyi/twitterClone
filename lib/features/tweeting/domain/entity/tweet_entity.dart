import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class TweetEntity extends Equatable {
  final String id;
  final String userId;
  final DocumentReference userProfile;
  final DocumentReference retweetersProfile;
  final String message;
  final DocumentReference quoteTo;
  final DocumentReference retweetTo;
  final DocumentReference commentTo;
  final int noOfComments;
  final List retweetedBy;
  final List likedBy;
  final List quotedBy;
  final List images;
  final bool isQuote;
  final bool isRetweet;
  final bool isComment;
  final bool hasMedia;
  final Timestamp timeStamp;

  TweetEntity({
    @required this.id,
    this.userId,
    this.userProfile,
    @required this.message,
    @required this.timeStamp,
    this.retweetersProfile,
    this.retweetTo,
    this.quoteTo,
    this.commentTo,
    this.noOfComments,
    this.images,
    this.retweetedBy,
    this.likedBy,
    this.quotedBy,
    this.isQuote,
    this.isRetweet,
    this.hasMedia,
    this.isComment
  });

  TweetEntity copyWith({
    String userId,
    String message,
    DocumentReference userProfile,
    List likedBy,
    List quotedBy,
    List images,
    List retweetedBy,
    int noOfComments,
    DocumentReference quoteTo,
    DocumentReference commentTo,
    DocumentReference retweetTo,
    bool isQuote,
    bool isRetweet,
    bool isComment,
    bool hasMedia,
    DocumentReference retweetersProfile,
  }) {
    return TweetEntity(
      id: this.id,
      userId: userId ?? this.userId,
      userProfile: userProfile ?? this.userProfile,
      message: message ?? this.message,
      quoteTo: quoteTo ?? this.quoteTo,
      commentTo: commentTo ?? this.commentTo,
      retweetTo: retweetTo ?? this.retweetTo,
      noOfComments: noOfComments ?? this.noOfComments,
      retweetersProfile: retweetersProfile ?? this.retweetersProfile,
      retweetedBy: retweetedBy ?? this.retweetedBy,
      likedBy: likedBy ?? this.likedBy,
      quotedBy: quotedBy ?? this.quotedBy,
      images: images ?? this.images,
      isQuote: isQuote ?? this.isQuote,
      isRetweet: isRetweet ?? this.isRetweet,
      hasMedia: hasMedia ?? this.hasMedia,
      isComment: isComment ?? this.isComment,
      timeStamp: this.timeStamp,
    );
  }

  String getTime(Timestamp timeStamp) {
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

  @override
  List<Object> get props => [message, timeStamp];
}
