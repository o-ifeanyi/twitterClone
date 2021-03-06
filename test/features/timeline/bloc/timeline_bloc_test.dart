import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/timeline_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.dart';

void main() {
  MockCollectionReference collectionReference;
  // ignore: close_sinks
  StreamController streamController;
  TimeLineBloc timeLineBloc;
  MockTimeLineRepository mockTimeLineRepository;

  setUp(() {
    collectionReference = MockCollectionReference();
    mockTimeLineRepository = MockTimeLineRepository();
    streamController = StreamController<QuerySnapshot>();
    timeLineBloc = TimeLineBloc(
      initialState: InitialTimeLineState(),
      timeLineRepository: mockTimeLineRepository,
    );
  });

  test(('confirm initial bloc state'), () {
    expect(timeLineBloc.state, equals(InitialTimeLineState()));
  });
  group('timeline bloc fetchTweets event', () {

    test(
        'should emit [FetchingTweet, FetchingTweetComplete] when successful',
        () async {
      when(collectionReference.snapshots())
          .thenAnswer((_) => streamController.stream);
      when(mockTimeLineRepository.fetchTweets()).thenAnswer(
        (_) => Future.value(
            Right(StreamConverter(collection: collectionReference))),
      );

      final expectations = [
        FetchingTweet(),
        FetchingTweetComplete(),
      ];
      expectLater(timeLineBloc, emitsInOrder(expectations));

      timeLineBloc.add(FetchTweet());
    });

    test(
        'should emit [FetchingTweet, FetchingTweetFailed] when it fails',
        () async {
      when(mockTimeLineRepository.fetchTweets()).thenAnswer(
        (_) => Future.value(
            Left(TimeLineFailure(message: 'Failed to load tweets'))),
      );
      final expectations = [
        FetchingTweet(),
        FetchingTweetError(message: 'Failed to load tweets'),
      ];
      expectLater(timeLineBloc, emitsInOrder(expectations));

      timeLineBloc.add(FetchTweet());
    });
  });
}
