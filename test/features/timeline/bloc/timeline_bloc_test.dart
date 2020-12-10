import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/util/stream_converter.dart';
import 'package:fc_twitter/features/timeline/data/model/tweet_model.dart';
import 'package:fc_twitter/features/timeline/data/repository/timeline_repository.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTimeLineRepository extends Mock implements TimeLineRepositoryImpl {}

void main() {
  TweetModel tweetModel;
  MockTimeLineRepository mockTimeLineRepository;
  TimeLineBloc timeLineBloc;

  setUp(() {
    tweetModel = TweetModel(
      name: 'ifeanyi',
      userName: 'onuoha',
      message: 'hello world, testing',
      timeStamp: Timestamp.now(),
    );
    mockTimeLineRepository = MockTimeLineRepository();
    timeLineBloc = TimeLineBloc(
      initialState: InitialTimeLineState(),
      repositoryImpl: mockTimeLineRepository,
    );
  });

  test(('confirm inistial bloc state'), () {
    expect(timeLineBloc.state, equals(InitialTimeLineState()));
  });
  group('timeline bloc test', () {
    test(
        'should emit [SendingTweet, SendingComplete] when tweet is sent successfully',
        () async {
      when(mockTimeLineRepository.sendTweet(tweetModel)).thenAnswer(
        (_) => Future.value(Right(true)),
      );

      final expectations = [
        SendingTweet(),
        SendingComplete(),
      ];
      expectLater(timeLineBloc, emitsInOrder(expectations));

      timeLineBloc.add(SendTweet(tweet: tweetModel));
    });

    test('should emit [SendingTweet, SendingFailed] when sending tweet fails',
        () async {
      when(mockTimeLineRepository.sendTweet(tweetModel)).thenAnswer(
        (_) => Future.value(Left(TimeLineFailure(message:'Failed to send tweet'))),
      );

      final expectations = [
        SendingTweet(),
        SendingError(message:'Failed to send tweet'),
      ];
      expectLater(timeLineBloc, emitsInOrder(expectations));

      timeLineBloc.add(SendTweet(tweet: tweetModel));
    });

    test(
        'should emit [FetchingTweet, FetchingComplete] when fetching tweet is successful',
        () async {
      when(mockTimeLineRepository.fetchTweets()).thenAnswer(
        (_) => Future.value(Right(StreamConverter())),
      );

      final expectations = [
        FetchingTweet(),
        FetchingComplete(),
      ];
      expectLater(timeLineBloc, emitsInOrder(expectations));

      timeLineBloc.add(FetchTweet());
    });

    test(
        'should emit [FetchingTweet, FetchingFailed] when fetching tweet fails',
        () async {
      when(mockTimeLineRepository.fetchTweets()).thenAnswer(
        (_) => Future.value(Left(TimeLineFailure(message:'Failed to load tweets'))),
      );
      final expectations = [
        FetchingTweet(),
        FetchingError(message:'Failed to load tweets'),
      ];
      expectLater(timeLineBloc, emitsInOrder(expectations));

      timeLineBloc.add(FetchTweet());
    });
  });
}
