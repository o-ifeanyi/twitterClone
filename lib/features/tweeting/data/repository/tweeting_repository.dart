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
  Future<Either<TweetingFailure, bool>> comment(TweetEntity tweet, TweetEntity commentTweet) async {
    try {
      int comments = tweet.noOfComments;
      comments++;
      tweet = tweet.copyWith(noOfComments: comments);
      await firebaseFirestore
          .collection(tweet.isComment ? 'comments' : 'tweets')
          .doc(tweet.id)
          .update({'noOfComments': comments});
      await firebaseFirestore
          .collection('comments')
          .add(TweetModel.fromEntity(commentTweet).toMap());
      if (tweet.isRetweet) {
        commentTweet = commentTweet.copyWith(commentTo: tweet.retweetTo);
        await comment(tweet.retweetTo, commentTweet);
      }
      return Right(true);
    } catch (error) {
      print(error);
      return Left(TweetingFailure(message: 'Failed to comment'));
    }
  }

  @override
  Future<Either<TweetingFailure, bool>> sendTweet(TweetEntity tweet) async {
    try {
      await firebaseFirestore
          .collection('tweets')
          .add(TweetModel.fromEntity(tweet).toMap());
      return Right(true);
    } catch (error) {
      print(error);
      return Left(TweetingFailure(message: 'Failed to send tweet'));
    }
  }

  @override
  Future<Either<TweetingFailure, bool>> likeTweet(
      UserProfileEntity userProfile, TweetEntity tweet) async {
    try {
      final likedBy = tweet.likedBy;
      likedBy?.add(UserProfileModel.fromEntity(userProfile).toMap());
      tweet = tweet.copyWith(likedBy: likedBy);
      await firebaseFirestore
          .collection(tweet.isComment && !tweet.isRetweet ? 'comments' : 'tweets')
          .doc(tweet.id)
          .update({'likedBy': likedBy});
      if (tweet.isRetweet) {
        await likeTweet(userProfile, tweet.retweetTo);
      }
      return Right(true);
    } catch (error) {
      print(error);
      return Left(TweetingFailure(message: 'Failed to like tweet'));
    }
  }

  @override
  Future<Either<TweetingFailure, bool>> unlikeTweet(
      UserProfileEntity userProfile, TweetEntity tweet) async {
    try {
      final likedBy = tweet.likedBy;
      likedBy?.removeWhere((element) => element['id'] == userProfile.id);
      tweet = tweet.copyWith(likedBy: likedBy);
      await firebaseFirestore
          .collection(tweet.isComment && !tweet.isRetweet ? 'comments' : 'tweets')
          .doc(tweet.id)
          .update({'likedBy': likedBy});
      if (tweet.isRetweet) {
        await unlikeTweet(userProfile, tweet.retweetTo);
      }
      return Right(true);
    } catch (error) {
      print(error);
      return Left(TweetingFailure(message: 'Failed to like tweet'));
    }
  }

  @override
  Future<Either<TweetingFailure, bool>> retweet(
      UserProfileEntity userProfile, TweetEntity tweet) async {
    try {
      final retweetedBy = tweet.retweetedBy;
      retweetedBy?.add(UserProfileModel.fromEntity(userProfile).toMap());
      tweet = tweet.copyWith(retweetedBy: retweetedBy);
      await firebaseFirestore
          .collection(tweet.isComment  && !tweet.isRetweet ? 'comments' : 'tweets')
          .doc(tweet.id)
          .update({'retweetedBy': retweetedBy});
      return Right(true);
    } catch (error) {
      print(error);
      return Left(TweetingFailure(message: 'Failed to retweet'));
    }
  }

  @override
  Future<Either<TweetingFailure, bool>> undoRetweet(
      UserProfileEntity userProfile, TweetEntity tweet) async {
    try {
      final retweetedBy = tweet.retweetedBy;
      retweetedBy?.removeWhere((element) => element['id'] == userProfile.id);
      tweet = tweet.copyWith(retweetedBy: retweetedBy);
      await firebaseFirestore
          .collection(tweet.isComment && !tweet.isRetweet ? 'comments' : 'tweets')
          .doc(tweet.id)
          .update({'retweetedBy': retweetedBy});
      if (tweet.isRetweet ?? false) {
        await undoRetweet(userProfile, tweet.retweetTo);
        await firebaseFirestore.collection('tweets').doc(tweet.id).delete();
      }
      return Right(true);
    } catch (error) {
      print(error);
      return Left(TweetingFailure(message: 'Failed to retweet'));
    }
  }
}
