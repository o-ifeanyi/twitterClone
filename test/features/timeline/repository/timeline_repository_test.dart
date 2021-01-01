import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/features/timeline/data/repository/timeline_repository.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';


void main() {
  TweetEntity tweetEntity;
  FirebaseFirestore mockFirebaseFirestore;
  TimeLineRepositoryImpl timeLineRepositoryImpl;
  MockCollectionReference collectionReference;

  setUp(() {
    tweetEntity = tweetEntityFixture();
    mockFirebaseFirestore = MockFirebaseFirestore();
    collectionReference = MockCollectionReference();
    timeLineRepositoryImpl =
        TimeLineRepositoryImpl(firebaseFirestore: mockFirebaseFirestore);
  });

  group('timeline repository fetchTweets', () {

    test('should return a StreamConverter when fetch tweet successful',
        () async {
      when(mockFirebaseFirestore.collection(any))
          .thenReturn(collectionReference);

      final response = await timeLineRepositoryImpl.fetchTweets();
      verify(timeLineRepositoryImpl.fetchTweets());

      expect(response, Right(StreamConverter(collection: collectionReference)));
    });

    test('should return a FetchingFailure when fetch tweet fails',
        () async {
      when(mockFirebaseFirestore.collection(any))
          .thenThrow(Error());

      final response = await timeLineRepositoryImpl.fetchTweets();
      verify(timeLineRepositoryImpl.fetchTweets());

      expect(response, Left(TimeLineFailure(message: 'Failed to load tweets')));
    });
  });

  group('timeline repository fetchComments', () {
    test('should return a StreamConverter when successful',
        () async {
      when(mockFirebaseFirestore.collection(any))
          .thenReturn(collectionReference);

      final response = await timeLineRepositoryImpl.fetchComments(tweetEntity);

      expect(response, Right(StreamConverter(collection: collectionReference)));
    });

    test('should return a FetchingFailure when fetchComment fails',
        () async {
      when(mockFirebaseFirestore.collection(any))
          .thenThrow(Error());

      final response = await timeLineRepositoryImpl.fetchComments(tweetEntity);

      expect(response, Left(TimeLineFailure(message: 'Failed to load comments')));
    });
  });
}
