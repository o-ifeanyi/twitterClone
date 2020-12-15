import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
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
      await firebaseFirestore.collection('tweets').add(TweetModel.fromEntity(tweet).toDocument());
      return Right(true);
    } catch (error) {
      return Left(TweetingFailure(message: 'Failed to send tweet'));
    }
  }
}