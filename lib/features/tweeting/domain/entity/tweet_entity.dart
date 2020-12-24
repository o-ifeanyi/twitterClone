import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:flutter/cupertino.dart';

class TweetEntity extends Equatable {
  final String id;
  final UserProfileEntity userProfile;
  final String message;
  final Map<String, dynamic> quoteTo;
  final List comments;
  final List retweetedBy;
  final List likedBy;
  final bool isRetweet;
  final dynamic timeStamp;

  TweetEntity({
    @required this.id,
    @required this.userProfile,
    @required this.message,
    @required this.timeStamp,
    this.quoteTo,
    this.comments,
    this.retweetedBy,
    this.likedBy,
    this.isRetweet,
  });

  TweetEntity copyWith({List<dynamic> likedBy}) {
    return TweetEntity(
      id: this.id,
      userProfile: this.userProfile,
      message: this.message,
      quoteTo: this.quoteTo,
      comments: this.comments,
      retweetedBy: this.retweetedBy,
      likedBy: likedBy ?? this.likedBy,
      isRetweet: this.isRetweet,
      timeStamp: this.timeStamp,
    );
  }

  @override
  List<Object> get props => [userProfile, message, timeStamp];
}
