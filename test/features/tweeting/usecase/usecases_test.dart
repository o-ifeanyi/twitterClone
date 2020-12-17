import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/domain/repository/tweeting_repository.dart';
import 'package:fc_twitter/features/tweeting/domain/usecase/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.dart';


void main() {
  TweetEntity tweetEntity;
  TweetingRepository  tweetingRepository;
  SendTweetUseCase sendTweet;

  setUp(() {
    tweetEntity = TweetEntity(
      name: 'ifeanyi',
      userName: 'onuoha',
      message: 'hello world, testing',
      timeStamp: Timestamp.now(),
    );
    tweetingRepository = MockTweetingRepository();
    sendTweet = SendTweetUseCase(tweetingRepository: tweetingRepository);
  });

  group('sentTweet use case', () {
    
    test('should return true when tweet is sent successfully', () async {
      when(tweetingRepository.sendTweet(any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );

      final result = await sendTweet(TParams(tweet: tweetEntity));

      expect(result, Right(true));
      verify(tweetingRepository.sendTweet(any));
    });

    test('should return TimelineFailure when tweet is not sent successfully', () async {
      when(tweetingRepository.sendTweet(any)).thenAnswer(
        (_) => Future.value(Left(TweetingFailure())),
      );

      final result = await sendTweet(TParams(tweet: tweetEntity));

      expect(result, Left(TweetingFailure()));
      verify(tweetingRepository.sendTweet(any));
    });
  });
}
