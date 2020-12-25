import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/tweeting/data/model/tweet_model.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/domain/repository/tweeting_repository.dart';

class TweetingRepositoryImpl implements TweetingRepository {
  final FirebaseFirestore firebaseFirestore;

  TweetingRepositoryImpl({this.firebaseFirestore})
      : assert(firebaseFirestore != null);
  @override
  Future<Either<TweetingFailure, bool>> sendTweet(TweetEntity tweet) async {
    try {
      await firebaseFirestore
          .collection('tweets')
          .add(TweetModel.fromEntity(tweet).toDocument());
      return Right(true);
    } catch (error) {
      print(error);
      return Left(TweetingFailure(message: 'Failed to send tweet'));
    }
  }

  @override
  Future<Either<TweetingFailure, bool>> likeOrUnlikeTweet(
      UserProfileEntity userProfile, TweetEntity tweet) async {
    try {
      final likedBy = tweet.likedBy;
      final found = likedBy?.any((element) => element['id'] == userProfile.id);
      if (found ?? false) {
        likedBy?.removeWhere((element) => element['id'] == userProfile.id);
      } else {
        likedBy?.add(UserProfileModel.fromEntity(userProfile).toMap());
      }
      tweet = tweet.copyWith(likedBy: likedBy);
      await firebaseFirestore
          .collection('tweets')
          .doc(tweet.id)
          .update({'likedBy': likedBy});
      return Right(true);
    } catch (error) {
      print(error);
      return Left(TweetingFailure(message: 'Failed to like tweet'));
    }
  }

  @override
  Future<Either<TweetingFailure, bool>> retweetTweet(UserProfileEntity userProfile, TweetEntity tweet) async{
    try {
      final retweetedBy = tweet.retweetedBy;
      final found = retweetedBy?.any((element) => element['id'] == userProfile.id) ?? false;
      if (found) {
        retweetedBy?.removeWhere((element) => element['id'] == userProfile.id);
      } else {
        retweetedBy?.add(UserProfileModel.fromEntity(userProfile).toMap());
      }
      tweet = tweet.copyWith(retweetedBy: retweetedBy);
      await firebaseFirestore
          .collection('tweets')
          .doc(tweet.id)
          .update({'retweetedBy': retweetedBy});
      return Right(found);
    } catch (error) {
      print(error);
      return Left(TweetingFailure(message: 'Failed to retweet'));
    }
  }
}
