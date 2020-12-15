import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/tweeting/data/repository/tweeting_repository.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.dart';

void main() {
  TweetEntity tweetEntity;
  FirebaseFirestore mockFirebaseFirestore;
  TweetingRepositoryImpl tweetingRepositoryImpl;
  MockCollectionReference collectionReference;
  MockDocumentReference documentReference;

  setUp(() {
    tweetEntity = TweetEntity(
      name: 'ifeanyi',
      userName: 'onuoha',
      message: 'hello world',
      timeStamp: Timestamp.now(),
    );
    mockFirebaseFirestore = MockFirebaseFirestore();
    collectionReference = MockCollectionReference();
    documentReference = MockDocumentReference();
    tweetingRepositoryImpl =
        TweetingRepositoryImpl(firebaseFirestore: mockFirebaseFirestore);
  });

  group('timeline test', () {
    test(
        'should return a true when sentTweet is called successfully',
        () async {
      when(mockFirebaseFirestore.collection(any))
          .thenReturn(collectionReference);
      when(collectionReference.add(any))
          .thenAnswer((_) => Future.value(documentReference));

      final response = await tweetingRepositoryImpl.sendTweet(tweetEntity);
      verify(tweetingRepositoryImpl.sendTweet(tweetEntity));

      expect(response, Right(true));
    });

    test('should return a TweetingFailure when sendTweet fails', () async {
      when(mockFirebaseFirestore.collection(any)).thenThrow(Error());

      final response = await tweetingRepositoryImpl.sendTweet(tweetEntity);
      verify(tweetingRepositoryImpl.sendTweet(tweetEntity));

      expect(response, Left(TweetingFailure(message: 'Failed to send tweet')));
    });
  });
}
