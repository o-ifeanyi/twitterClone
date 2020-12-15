import 'package:equatable/equatable.dart';
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