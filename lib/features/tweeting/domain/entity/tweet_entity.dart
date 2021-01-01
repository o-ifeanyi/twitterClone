import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:flutter/cupertino.dart';

class TweetEntity extends Equatable {
  final String id;
  final UserProfileEntity userProfile;
  final UserProfileEntity retweetersProfile;
  final String message;
  final TweetEntity quoteTo;
  final TweetEntity retweetTo;
  final TweetEntity commentTo;
  final int noOfComments;
  final List retweetedBy;
  final List likedBy;
  final bool isRetweet;
  final bool isComment;
  final Timestamp timeStamp;

  TweetEntity({
    @required this.id,
    @required this.userProfile,
    @required this.message,
    @required this.timeStamp,
    this.retweetersProfile,
    this.retweetTo,
    this.quoteTo,
    this.commentTo,
    this.noOfComments,
    this.retweetedBy,
    this.likedBy,
    this.isRetweet,
    this.isComment
  });

  TweetEntity copyWith({
    List likedBy,
    List retweetedBy,
    int noOfComments,
    TweetEntity commentTo,
    TweetEntity retweetTo,
    bool isRetweet,
    UserProfileEntity retweetersProfile,
  }) {
    return TweetEntity(
      id: this.id,
      userProfile: this.userProfile,
      message: this.message,
      quoteTo: this.quoteTo,
      commentTo: commentTo ?? this.commentTo,
      retweetTo: retweetTo ?? this.retweetTo,
      noOfComments: noOfComments ?? this.noOfComments,
      retweetersProfile: retweetersProfile ?? this.retweetersProfile,
      retweetedBy: retweetedBy ?? this.retweetedBy,
      likedBy: likedBy ?? this.likedBy,
      isRetweet: isRetweet ?? this.isRetweet,
      isComment: this.isComment,
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
  List<Object> get props => [userProfile.id, userProfile.userName, message, timeStamp];
}
