import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/timeline/data/model/tweet_model.dart';

class TimeLineEvent extends Equatable {
  final TweetModel tweet;

  TimeLineEvent({this.tweet});

  @override
  List<Object> get props => [tweet];
}

class FetchTweet extends TimeLineEvent {}

class SendTweet extends TimeLineEvent {
  final TweetModel tweet;

  SendTweet({this.tweet});

  @override
  List<Object> get props => [tweet];
}