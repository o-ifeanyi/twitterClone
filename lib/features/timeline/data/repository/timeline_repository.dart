import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/features/timeline/data/model/tweet_model.dart';
import 'package:fc_twitter/features/timeline/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/timeline/domain/repository/timeline_repository.dart.dart';

class TimeLineRepositoryImpl implements TimeLineRepository {
  final FirebaseFirestore firebaseFirestore;

  TimeLineRepositoryImpl({this.firebaseFirestore})
      : assert(firebaseFirestore != null);

  @override
  Future<Either<TimeLineFailure, StreamConverter>> fetchTweets() async {
    try {
      final collection = firebaseFirestore.collection('tweets');
      return Right(StreamConverter(collection: collection));
    } catch (error) {
      return Left(TimeLineFailure(message: 'Failed to load tweets'));
    }
  }

  @override
  Future<Either<TimeLineFailure, bool>> sendTweet(TweetEntity tweet) async {
    try {
      await firebaseFirestore.collection('tweets').add(TweetModel.fromEntity(tweet).toDocument());
      return Right(true);
    } catch (error) {
      return Left(TimeLineFailure(message: 'Failed to send tweet'));
    }
  }
}
