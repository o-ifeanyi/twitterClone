import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:flutter/cupertino.dart';

class TweetEntity extends Equatable {
  final UserProfileEntity userProfile;
  final String message;
  final Map<String, dynamic> quoteTo;
  final List<Map<String, dynamic>> comments;
  final List<Map<String, dynamic>> retweetedBy;
  final List<Map<String, dynamic>> likedBy;
  final bool isRetweet;
  final dynamic timeStamp;

  TweetEntity({
    @required this.userProfile,
    @required this.message,
    @required this.timeStamp,
    this.quoteTo,
    this.comments,
    this.retweetedBy,
    this.likedBy,
    this.isRetweet,
  });

  @override
  List<Object> get props => [userProfile, message, timeStamp];
}
