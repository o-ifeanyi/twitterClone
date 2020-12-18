import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/tweeting/data/repository/tweeting_repository.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';

void main() {
  TweetEntity tweetEntity;
  FirebaseFirestore mockFirebaseFirestore;
  TweetingRepositoryImpl tweetingRepositoryImpl;
  MockCollectionReference collectionReference;
  MockDocumentReference documentReference;

  setUp(() {
    tweetEntity = tweetEntityFixture();
    mockFirebaseFirestore = MockFirebaseFirestore();
    collectionReference = MockCollectionReference();
    documentReference = MockDocumentReference();
    tweetingRepositoryImpl =
        TweetingRepositoryImpl(firebaseFirestore: mockFirebaseFirestore);
  });

  group('tweeting repository sendTeet', () {
    test(
        'should return a true when successful',
        () async {
      when(mockFirebaseFirestore.collection(any))
          .thenReturn(collectionReference);
      when(collectionReference.add(any))
          .thenAnswer((_) => Future.value(documentReference));

      final response = await tweetingRepositoryImpl.sendTweet(tweetEntity);
      verify(tweetingRepositoryImpl.sendTweet(tweetEntity));

      expect(response, Right(true));
    });

    test('should return a TweetingFailure when it fails', () async {
      when(mockFirebaseFirestore.collection(any)).thenThrow(Error());

      final response = await tweetingRepositoryImpl.sendTweet(tweetEntity);
      verify(tweetingRepositoryImpl.sendTweet(tweetEntity));

      expect(response, Left(TweetingFailure(message: 'Failed to send tweet')));
    });
  });
}
