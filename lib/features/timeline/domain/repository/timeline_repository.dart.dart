
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/features/timeline/data/model/tweet_model.dart';

abstract class TimeLineRepository {
  Future<Either<Failure, StreamConverter>> fetchTweets();

  Future<Either<Failure, bool>> sendTweet(TweetModel tweet);
}