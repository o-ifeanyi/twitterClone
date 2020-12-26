
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';

abstract class TweetingRepository {
  Future<Either<TweetingFailure, bool>> sendTweet(TweetEntity tweet);

  Future<Either<TweetingFailure, bool>> likeTweet(UserProfileEntity userProfile, TweetEntity tweet);

  Future<Either<TweetingFailure, bool>> unlikeTweet(UserProfileEntity userProfile, TweetEntity tweet);

  Future<Either<TweetingFailure, bool>> retweet(UserProfileEntity userProfile, TweetEntity tweet);

  Future<Either<TweetingFailure, bool>> undoRetweet(UserProfileEntity userProfile, TweetEntity tweet);
}