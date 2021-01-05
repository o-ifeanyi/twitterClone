import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';

class TweetingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendTweet extends TweetingEvent {
  final UserProfileEntity userProfile;
  final TweetEntity tweet;

  SendTweet({this.tweet, this.userProfile});

  @override
  List<Object> get props => [tweet];

}
class LikeTweet extends TweetingEvent {
  final UserProfileEntity userProfile;
  final TweetEntity tweet;

  LikeTweet({this.tweet, this.userProfile});

  @override
  List<Object> get props => [tweet, userProfile];
}

class UnlikeTweet extends TweetingEvent {
  final UserProfileEntity userProfile;
  final TweetEntity tweet;

  UnlikeTweet({this.tweet, this.userProfile});

  @override
  List<Object> get props => [tweet, userProfile];
}

class Retweet extends TweetingEvent {
  final UserProfileEntity userProfile;
  final TweetEntity tweet;

  Retweet({this.tweet, this.userProfile});

  @override
  List<Object> get props => [tweet, userProfile];
}

class UndoRetweet extends TweetingEvent {
  final UserProfileEntity userProfile;
  final TweetEntity tweet;

  UndoRetweet({this.tweet, this.userProfile});

  @override
  List<Object> get props => [tweet, userProfile];
}

class Comment extends TweetingEvent {
    final UserProfileEntity userProfile;
  final TweetEntity tweet;
  final TweetEntity comment;

  Comment({this.tweet, this.comment, this.userProfile});

  @override
  List<Object> get props => [tweet, comment];
}