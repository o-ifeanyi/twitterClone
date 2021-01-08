import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/features/timeline/domain/repository/timeline_repository.dart.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';

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
      print(error);
      return Left(TimeLineFailure(message: 'Failed to load tweets'));
    }
  }

  @override
  Future<Either<TimeLineFailure, StreamConverter>> fetchComments(
      TweetEntity tweet) async {
        print(tweet.id);
    try {
      final tweetReference = firebaseFirestore
          .collection('tweets')
          .doc(tweet.isRetweet ? tweet.retweetTo.id : tweet.id);
      final collection = firebaseFirestore
          .collection('tweets')
          .where('commentTo', isEqualTo: tweetReference).where('isRetweet', isEqualTo: false);
      return Right(StreamConverter(query: collection));
    } catch (error) {
      print(error);
      return Left(TimeLineFailure(message: 'Failed to load comments'));
    }
  }
}
