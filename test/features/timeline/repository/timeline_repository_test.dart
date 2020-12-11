import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/features/timeline/data/model/tweet_model.dart';
import 'package:fc_twitter/features/timeline/data/repository/timeline_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTimeLineRepository extends Mock implements TimeLineRepositoryImpl {}

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

void main() {
  TweetModel tweetModel;
  FirebaseFirestore mockFirebaseFirestore;
  TimeLineRepositoryImpl timeLineRepositoryImpl;
  MockCollectionReference collectionReference;
  MockDocumentReference documentReference;

  setUp(() {
    tweetModel = TweetModel(
      name: 'ifeanyi',
      userName: 'onuoha',
      message: 'hello world, testing',
      timeStamp: Timestamp.now(),
    );
    mockFirebaseFirestore = MockFirestore();
    collectionReference = MockCollectionReference();
    documentReference = MockDocumentReference();
    timeLineRepositoryImpl =
        TimeLineRepositoryImpl(firebaseFirestore: mockFirebaseFirestore);
  });

  group('timeline test', () {
    test('should return true when a tweet is sent successfully', () async {
       when(mockFirebaseFirestore.collection(any))
          .thenReturn(collectionReference);
      when(collectionReference.add(tweetModel.toDocument()))
          .thenAnswer((_) => Future.value(documentReference));

      final response = await timeLineRepositoryImpl.sendTweet(tweetModel);

      expect(response, Right(true));
    });

    test('should return sending failure when sending tweet is unsuccessful',
        () async {
      when(mockFirebaseFirestore.collection(any))
          .thenReturn(collectionReference);
      when(collectionReference.add(tweetModel.toDocument()))
          .thenThrow(Error());

      final response = await timeLineRepositoryImpl.sendTweet(tweetModel);

      expect(response, Left(TimeLineFailure(message: 'Failed to send tweet')));
    });

    test('should return a StreamConverter when fetch tweet is called',
        () async {
      when(mockFirebaseFirestore.collection(any))
          .thenReturn(collectionReference);

      final response = await timeLineRepositoryImpl.fetchTweets();
      verify(timeLineRepositoryImpl.fetchTweets());

      expect(response, Right(StreamConverter(collection: collectionReference)));
    });
  });
}
