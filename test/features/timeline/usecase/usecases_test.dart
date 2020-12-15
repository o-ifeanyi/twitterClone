import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/timeline/domain/usecase/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.dart';


void main() {
  MockTimeLineRepository timeLineRepository;
  FetchTweetUseCase fetchTweet;
  // SendTweetUseCase sendTweet;

  setUp(() {
    timeLineRepository = MockTimeLineRepository();
    fetchTweet =
        FetchTweetUseCase(timeLineRepository: timeLineRepository);
    // sendTweet = SendTweetUseCase(timeLineRepository: timeLineRepository);
  });

  group('use case', () {

    test('should return a StreamConverter when tweet fetched successfully', () async {
      when(timeLineRepository.fetchTweets()).thenAnswer(
        (_) => Future.value(Right(StreamConverter())),
      );

      final result = await fetchTweet(NoParams());

      expect(result, Right(StreamConverter()));
      verify(timeLineRepository.fetchTweets());
    });

    test('should return TimelineFailure when tweet is not sent successfully', () async {
      when(timeLineRepository.fetchTweets()).thenAnswer(
        (_) => Future.value(Left(TimeLineFailure())),
      );

      final result = await fetchTweet(NoParams());

      expect(result, Left(TimeLineFailure()));
      verify(timeLineRepository.fetchTweets());
    });

    // test('should return true when tweet is sent successfully', () async {
    //   when(timeLineRepository.sendTweet(any)).thenAnswer(
    //     (_) => Future.value(Right(true)),
    //   );

    //   final result = await sendTweet(TParams(tweet: tweetEntity));

    //   expect(result, Right(true));
    //   verify(timeLineRepository.sendTweet(any));
    // });

    // test('should return TimelineFailure when tweet is not sent successfully', () async {
    //   when(timeLineRepository.sendTweet(any)).thenAnswer(
    //     (_) => Future.value(Left(TimeLineFailure())),
    //   );

    //   final result = await sendTweet(TParams(tweet: tweetEntity));

    //   expect(result, Left(TimeLineFailure()));
    //   verify(timeLineRepository.sendTweet(any));
    // });
  });
}
