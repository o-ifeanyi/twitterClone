import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/features/timeline/data/model/tweet_model.dart';
import 'package:fc_twitter/features/timeline/data/repository/timeline_repository.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTimeLineRepository extends Mock implements TimeLineRepositoryImpl {}

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

void main() {
  TweetModel tweetModel;
  MockTimeLineRepository mockTimeLineRepository;
  FirebaseFirestore mockFirebaseFirestore;
  MockCollectionReference collectionReference;
  // ignore: close_sinks
  StreamController streamController;
  TimeLineBloc timeLineBloc;

  setUp(() {
    tweetModel = TweetModel(
      name: 'ifeanyi',
      userName: 'onuoha',
      message: 'hello world, testing',
      timeStamp: Timestamp.now(),
    );
    mockTimeLineRepository = MockTimeLineRepository();
    mockFirebaseFirestore = MockFirestore();
    collectionReference = MockCollectionReference();
    streamController = StreamController<QuerySnapshot>();
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
        'should emit [SendingComplete] first when tweet is sent successfully',
        () async {
      when(mockTimeLineRepository.sendTweet(tweetModel)).thenAnswer(
        (_) => Future.value(Right(true)),
      );

      final expectations = [
        SendingComplete(),
      ];
      expectLater(timeLineBloc, emitsInOrder(expectations));

      timeLineBloc.add(SendTweet(tweet: tweetModel));
    });

    test('should emit [SendingError] first when sending tweet fails',
        () async {
      when(mockTimeLineRepository.sendTweet(tweetModel)).thenAnswer(
        (_) => Future.value(Left(TimeLineFailure(message:'Failed to send tweet'))),
      );

      final expectations = [
        SendingError(message:'Failed to send tweet'),
      ];
      expectLater(timeLineBloc, emitsInOrder(expectations));

      timeLineBloc.add(SendTweet(tweet: tweetModel));
    });

    test(
        'should emit [FetchingTweet, FetchingComplete] when fetching tweet is successful',
        () async {
      when(mockFirebaseFirestore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.snapshots()).thenAnswer((_) => streamController.stream);
      when(mockTimeLineRepository.fetchTweets()).thenAnswer(
        (_) => Future.value(Right(StreamConverter(collection: mockFirebaseFirestore.collection('tweets')))),
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
