import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/representation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';

void main() {
  TweetEntity tweetEntity;
  UserProfileEntity userProfile;
  MockCollectionReference collectionReference;
  // ignore: close_sinks
  StreamController streamController;
  TweetingBloc tweetingBloc;
  MockTweetingRepository mockTweetingRepository;

  setUp(() {
    tweetEntity = tweetEntityFixture();
    userProfile = userProfileEntityFixture();
    mockTweetingRepository = MockTweetingRepository();
    collectionReference = MockCollectionReference();
    streamController = StreamController<QuerySnapshot>();
    tweetingBloc = TweetingBloc(
      initialState: InitialTweetingState(),
      tweetingRepository: mockTweetingRepository,
    );
  });

  test(('confirm inistial bloc state'), () {
    expect(tweetingBloc.state, equals(InitialTweetingState()));
  });

  void setUpFetchSuccess() {
    when(collectionReference.snapshots())
        .thenAnswer((_) => streamController.stream);
  }

  group('tweeting bloc sendTweet', () {
    test('should emit [TweetingComplete] when successful',
        () async {
      when(mockTweetingRepository.sendTweet(any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );
      setUpFetchSuccess();

      final expectations = [
        TweetingComplete(),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc.add(SendTweet(tweet: tweetEntity));
    });

    test('should emit [TweetingError] when sending tweet fails', () async {
      when(mockTweetingRepository.sendTweet(any)).thenAnswer(
        (_) => Future.value(
            Left(TweetingFailure(message: 'Failed to send tweet'))),
      );
      setUpFetchSuccess();

      final expectations = [
        TweetingError(message: 'Failed to send tweet'),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc.add(SendTweet(tweet: tweetEntity));
    });
  });
  group('tweeting bloc likeTweet', () {
    test('should emit [TweetingComplete] when successful',
        () async {
      when(mockTweetingRepository.likeOrUnlikeTweet(any, any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );

      final expectations = [
        TweetingComplete(),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc.add(LikeOrUnlikeTweet(userProfile: userProfile, tweet: tweetEntity));
    });

    test('should emit [TweetingError] when sending tweet fails', () async {
      when(mockTweetingRepository.likeOrUnlikeTweet(any, any)).thenAnswer(
        (_) => Future.value(
            Left(TweetingFailure(message: 'Failed to like tweet'))),
      );
      setUpFetchSuccess();

      final expectations = [
        TweetingError(message: 'Failed to like tweet'),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc.add(LikeOrUnlikeTweet(userProfile: userProfile, tweet: tweetEntity));
    });
  });
}
