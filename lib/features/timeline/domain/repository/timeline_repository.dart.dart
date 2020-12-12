
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/features/timeline/domain/entity/tweet_entity.dart';

abstract class TimeLineRepository {
  Future<Either<TimeLineFailure, StreamConverter>> fetchTweets();

  Future<Either<TimeLineFailure, bool>> sendTweet(TweetEntity tweet);
}