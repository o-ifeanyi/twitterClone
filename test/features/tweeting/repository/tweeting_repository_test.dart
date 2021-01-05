import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/tweeting/data/repository/tweeting_repository.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';

void main() {
  TweetEntity tweetEntity;
  UserProfileEntity userProfile;
  FirebaseFirestore mockFirebaseFirestore;
  TweetingRepositoryImpl tweetingRepositoryImpl;
  MockCollectionReference collectionReference;
  MockDocumentReference documentReference;

  setUp(() {
    tweetEntity = tweetEntityFixture();
    userProfile = userProfileEntityFixture();
    mockFirebaseFirestore = MockFirebaseFirestore();
    collectionReference = MockCollectionReference();
    documentReference = MockDocumentReference();
    tweetingRepositoryImpl =
        TweetingRepositoryImpl(firebaseFirestore: mockFirebaseFirestore);
  });

  group('tweeting repository sendTeet', () {
    test('should return a true when successful', () async {
      when(mockFirebaseFirestore.collection(any))
          .thenReturn(collectionReference);
      when(collectionReference.add(any))
          .thenAnswer((_) => Future.value(documentReference));

      final response =
          await tweetingRepositoryImpl.sendTweet(userProfile, tweetEntity);

      expect(response, Right(true));
    });

    test('should return a TweetingFailure when it fails', () async {
      when(mockFirebaseFirestore.collection(any)).thenThrow(Error());

      final response =
          await tweetingRepositoryImpl.sendTweet(userProfile, tweetEntity);

      expect(response, Left(TweetingFailure(message: 'Failed to send tweet')));
    });
  });

  group('tweeting repository likeTweet', () {
    test('should return true if tweet is liked successfully', () async {
      when(mockFirebaseFirestore.collection(any))
          .thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenReturn(documentReference);
      when(documentReference.update(any)).thenAnswer((_) => null);

      final result =
          await tweetingRepositoryImpl.likeTweet(userProfile, tweetEntity);

      expect(result, equals(Right(true)));
    });

    test('should return a TweetingFailure when it fails', () async {
      when(mockFirebaseFirestore.collection(any)).thenThrow(Error());

      final response =
          await tweetingRepositoryImpl.likeTweet(userProfile, tweetEntity);

      expect(response, Left(TweetingFailure(message: 'Failed to like tweet')));
    });
  });

  group('tweeting repository unlikeTweet', () {
    test('should return true if tweet is liked successfully', () async {
      when(mockFirebaseFirestore.collection(any))
          .thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenReturn(documentReference);
      when(documentReference.update(any)).thenAnswer((_) => null);

      final result =
          await tweetingRepositoryImpl.unlikeTweet(userProfile, tweetEntity);

      expect(result, equals(Right(true)));
    });

    test('should return a TweetingFailure when it fails', () async {
      when(mockFirebaseFirestore.collection(any)).thenThrow(Error());

      final response =
          await tweetingRepositoryImpl.unlikeTweet(userProfile, tweetEntity);

      expect(response, Left(TweetingFailure(message: 'Failed to like tweet')));
    });
  });

  group('tweeting repository retweet', () {
    test('should return true if tweet is retweeted successfully', () async {
      when(mockFirebaseFirestore.collection(any))
          .thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenReturn(documentReference);
      when(documentReference.update(any)).thenAnswer((_) => null);

      final result =
          await tweetingRepositoryImpl.retweet(userProfile, tweetEntity);

      expect(result, equals(Right(true)));
    });

    test('should return a TweetingFailure when it fails', () async {
      when(mockFirebaseFirestore.collection(any)).thenThrow(Error());

      final response =
          await tweetingRepositoryImpl.retweet(userProfile, tweetEntity);

      expect(response, Left(TweetingFailure(message: 'Failed to retweet')));
    });
  });

  group('tweeting repository retweet', () {
    test('should return true if tweet is undoRetweet successfully', () async {
      when(mockFirebaseFirestore.collection(any))
          .thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenReturn(documentReference);
      when(documentReference.update(any)).thenAnswer((_) => null);

      final result =
          await tweetingRepositoryImpl.undoRetweet(userProfile, tweetEntity);

      expect(result, equals(Right(true)));
    });

    test('should return a TweetingFailure when it fails', () async {
      when(mockFirebaseFirestore.collection(any)).thenThrow(Error());

      final response =
          await tweetingRepositoryImpl.undoRetweet(userProfile, tweetEntity);

      expect(response, Left(TweetingFailure(message: 'Failed to retweet')));
    });
  });

  group('tweeting repository comment', () {
    test('should return true after commenting successfully', () async {
      when(mockFirebaseFirestore.collection(any))
          .thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenReturn(documentReference);
      when(documentReference.update(any)).thenAnswer((_) => null);

      final result = await tweetingRepositoryImpl.comment(
          userProfile: userProfile,
          tweet: tweetEntity,
          commentTweet: tweetEntity);

      expect(result, equals(Right(true)));
    });

    test('should return a TweetingFailure when it fails', () async {
      when(mockFirebaseFirestore.collection(any)).thenThrow(Error());

      final response = await tweetingRepositoryImpl.comment(
          userProfile: userProfile,
          tweet: tweetEntity,
          commentTweet: tweetEntity);

      expect(response, Left(TweetingFailure(message: 'Failed to comment')));
    });
  });
}
