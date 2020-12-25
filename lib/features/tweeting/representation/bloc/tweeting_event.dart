import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';

class TweetingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendTweet extends TweetingEvent {
  final TweetEntity tweet;

  SendTweet({this.tweet});

  @override
  List<Object> get props => [tweet];

}
class LikeOrUnlikeTweet extends TweetingEvent {
  final UserProfileEntity userProfile;
  final TweetEntity tweet;

  LikeOrUnlikeTweet({this.tweet, this.userProfile});

  @override
  List<Object> get props => [tweet, userProfile];
}

class RetweetTweet extends TweetingEvent {
  final UserProfileEntity userProfile;
  final TweetEntity tweet;

  RetweetTweet({this.tweet, this.userProfile});

  @override
  List<Object> get props => [tweet, userProfile];
}