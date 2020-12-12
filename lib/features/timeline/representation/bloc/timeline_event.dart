import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/timeline/domain/entity/tweet_entity.dart';

class TimeLineEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchTweet extends TimeLineEvent {}

class SendTweet extends TimeLineEvent {
  final TweetEntity tweet;

  SendTweet({this.tweet});

  @override
  List<Object> get props => [tweet];
}