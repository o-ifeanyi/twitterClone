import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/util/stream_converter.dart';
import 'package:fc_twitter/features/timeline/data/model/tweet_model.dart';
import 'package:fc_twitter/features/timeline/data/repository/timeline_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTimeLineRepository extends Mock implements TimeLineRepositoryImpl {}
void main() {
  TweetModel tweetModel;
  FirebaseFirestore mockFirebaseFirestore;
  TimeLineRepositoryImpl timeLineRepositoryImpl;

  setUp(() {
    tweetModel = TweetModel(
      name: 'ifeanyi',
      userName: 'onuoha',
      message: 'hello world, testing',
      timeStamp: Timestamp.now(),
    );
    mockFirebaseFirestore = MockFirestoreInstance();
    timeLineRepositoryImpl =
        TimeLineRepositoryImpl(firebaseFirestore: mockFirebaseFirestore);
  });

  group('timeline test', () {
    test('should return true when a tweet is sent successfully', () async {

      final response = await timeLineRepositoryImpl.sendTweet(tweetModel);

      expect(response, Right(true));
    });

    test('should return sending failure when sending tweet is unsuccessful', () async {

      final response = await timeLineRepositoryImpl.sendTweet(null);

      expect(response, Left(TimeLineFailure(message:'Failed to send tweet')));
    });

    test('should return a list of tweetModels when fetch tweet is called', () async {
      final collection = mockFirebaseFirestore.collection('tweets');

      final response = await timeLineRepositoryImpl.fetchTweets();

      expect(response, Right(StreamConverter(stream: collection.snapshots())));
    });
  });
}
