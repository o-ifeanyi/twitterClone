import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

abstract class TweetingRepository {
  Future<Either<TweetingFailure, bool>> comment(
      {UserProfileEntity userProfile,
      TweetEntity tweet,
      TweetEntity commentTweet});

  Future<Either<TweetingFailure, bool>> quoteTweet(
      {UserProfileEntity userProfile,
      TweetEntity tweet,
      TweetEntity quoteTweet});

  Future<Either<TweetingFailure, bool>> sendTweet(
      UserProfileEntity userProfile, TweetEntity tweet);

  Future<Either<TweetingFailure, bool>> likeTweet(
      UserProfileEntity userProfile, TweetEntity tweet);

  Future<Either<TweetingFailure, bool>> unlikeTweet(
      UserProfileEntity userProfile, TweetEntity tweet);

  Future<Either<TweetingFailure, bool>> retweet(
      UserProfileEntity userProfile, TweetEntity tweet);

  Future<Either<TweetingFailure, bool>> undoRetweet(
      UserProfileEntity userProfile, TweetEntity tweet);

  Future<Either<TweetingFailure, List<Asset>>> pickImages();

  Future<Either<TweetingFailure, List<String>>> uploadImages(
      List<Asset> images);
}
