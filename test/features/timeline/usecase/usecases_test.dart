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

  setUp(() {
    timeLineRepository = MockTimeLineRepository();
    fetchTweet =
        FetchTweetUseCase(timeLineRepository: timeLineRepository);
  });

  group('fetchTweet use case', () {

    test('should return a StreamConverter when successful', () async {
      when(timeLineRepository.fetchTweets()).thenAnswer(
        (_) => Future.value(Right(StreamConverter())),
      );

      final result = await fetchTweet(NoParams());

      expect(result, Right(StreamConverter()));
      verify(timeLineRepository.fetchTweets());
    });

    test('should return TimelineFailure when un-successfully', () async {
      when(timeLineRepository.fetchTweets()).thenAnswer(
        (_) => Future.value(Left(TimeLineFailure())),
      );

      final result = await fetchTweet(NoParams());

      expect(result, Left(TimeLineFailure()));
      verify(timeLineRepository.fetchTweets());
    });
  });
}
