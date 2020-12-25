import 'dart:async';

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
  TweetingBloc tweetingBloc;
  MockTweetingRepository mockTweetingRepository;

  setUp(() {
    tweetEntity = tweetEntityFixture();
    userProfile = userProfileEntityFixture();
    mockTweetingRepository = MockTweetingRepository();
    tweetingBloc = TweetingBloc(
      initialState: InitialTweetingState(),
      tweetingRepository: mockTweetingRepository,
    );
  });

  test(('confirm inistial bloc state'), () {
    expect(tweetingBloc.state, equals(InitialTweetingState()));
  });

  group('tweeting bloc sendTweet', () {
    test('should emit [TweetingComplete] when successful',
        () async {
      when(mockTweetingRepository.sendTweet(any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );

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

      final expectations = [
        TweetingError(message: 'Failed to like tweet'),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc.add(LikeOrUnlikeTweet(userProfile: userProfile, tweet: tweetEntity));
    });
  });
  group('tweeting bloc retweetTweet', () {
    test('should emit [TweetingComplete] when successful',
        () async {
      when(mockTweetingRepository.retweetTweet(any, any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );
      when(mockTweetingRepository.sendTweet(any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );

      final expectations = [
        TweetingComplete(),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc.add(RetweetTweet(userProfile: userProfile, tweet: tweetEntity));
    });

    test('should emit [TweetingError] when sending tweet fails', () async {
      when(mockTweetingRepository.retweetTweet(any, any)).thenAnswer(
        (_) => Future.value(
            Left(TweetingFailure(message: 'Failed to retweet'))),
      );

      final expectations = [
        TweetingError(message: 'Failed to retweet'),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc.add(RetweetTweet(userProfile: userProfile, tweet: tweetEntity));
    });
  });
}
