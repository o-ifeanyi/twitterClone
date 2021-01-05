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

  group('tweeting bloc SendTweet', () {
    test('should emit [TweetingComplete] when successful', () async {
      when(mockTweetingRepository.sendTweet(any, any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );

      final expectations = [
        TweetingComplete(),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc.add(SendTweet(tweet: tweetEntity));
    });

    test('should emit [TweetingError] when sending tweet fails', () async {
      when(mockTweetingRepository.sendTweet(any, any)).thenAnswer(
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
  group('tweeting bloc LikeTweet', () {
    test('should emit [TweetingComplete] when successful', () async {
      when(mockTweetingRepository.likeTweet(any, any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );

      final expectations = [
        TweetingComplete(),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc.add(LikeTweet(userProfile: userProfile, tweet: tweetEntity));
    });

    test('should emit [TweetingError] when sending tweet fails', () async {
      when(mockTweetingRepository.likeTweet(any, any)).thenAnswer(
        (_) => Future.value(
            Left(TweetingFailure(message: 'Failed to like tweet'))),
      );

      final expectations = [
        TweetingError(message: 'Failed to like tweet'),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc.add(LikeTweet(userProfile: userProfile, tweet: tweetEntity));
    });
  });

  group('tweeting bloc UnlikeTweet', () {
    test('should emit [TweetingComplete] when successful', () async {
      when(mockTweetingRepository.unlikeTweet(any, any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );

      final expectations = [
        TweetingComplete(),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc
          .add(UnlikeTweet(userProfile: userProfile, tweet: tweetEntity));
    });

    test('should emit [TweetingError] when sending tweet fails', () async {
      when(mockTweetingRepository.unlikeTweet(any, any)).thenAnswer(
        (_) => Future.value(
            Left(TweetingFailure(message: 'Failed to unLike tweet'))),
      );

      final expectations = [
        TweetingError(message: 'Failed to unLike tweet'),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc
          .add(UnlikeTweet(userProfile: userProfile, tweet: tweetEntity));
    });
  });
  group('tweeting bloc Retweet', () {
    test('should emit [TweetingComplete] when successful', () async {
      when(mockTweetingRepository.retweet(any, any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );
      when(mockTweetingRepository.sendTweet(any, any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );

      final expectations = [
        TweetingComplete(),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc.add(Retweet(userProfile: userProfile, tweet: tweetEntity));
    });

    test('should emit [TweetingError] when sending tweet fails', () async {
      when(mockTweetingRepository.retweet(any, any)).thenAnswer(
        (_) =>
            Future.value(Left(TweetingFailure(message: 'Failed to retweet'))),
      );

      final expectations = [
        TweetingError(message: 'Failed to retweet'),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc.add(Retweet(userProfile: userProfile, tweet: tweetEntity));
    });
  });

  group('tweeting bloc UndoRetweet', () {
    test('should emit [TweetingComplete] when successful', () async {
      when(mockTweetingRepository.undoRetweet(any, any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );

      final expectations = [
        TweetingComplete(),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc
          .add(UndoRetweet(userProfile: userProfile, tweet: tweetEntity));
    });

    test('should emit [TweetingError] when sending tweet fails', () async {
      when(mockTweetingRepository.undoRetweet(any, any)).thenAnswer(
        (_) => Future.value(
            Left(TweetingFailure(message: 'Failed to undo retweet'))),
      );

      final expectations = [
        TweetingError(message: 'Failed to undo retweet'),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc
          .add(UndoRetweet(userProfile: userProfile, tweet: tweetEntity));
    });
  });

  group('tweeting bloc Coomment', () {
    test('should emit [TweetingComplete] when successful', () async {
      when(mockTweetingRepository.comment(
              userProfile: userProfile,
              tweet: tweetEntity,
              commentTweet: tweetEntity))
          .thenAnswer(
        (_) => Future.value(Right(true)),
      );

      final expectations = [
        TweetingComplete(),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc.add(Comment(
          userProfile: userProfile, comment: tweetEntity, tweet: tweetEntity));
    });

    test('should emit [TweetingError] when sending tweet fails', () async {
      when(mockTweetingRepository.comment(
              userProfile: userProfile,
              tweet: tweetEntity,
              commentTweet: tweetEntity))
          .thenAnswer(
        (_) =>
            Future.value(Left(TweetingFailure(message: 'Failed to comment'))),
      );

      final expectations = [
        TweetingError(message: 'Failed to comment'),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc.add(Comment(userProfile: userProfile, comment: tweetEntity, tweet: tweetEntity));
    });
  });
}
