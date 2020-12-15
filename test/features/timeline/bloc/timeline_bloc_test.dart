import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.dart';

void main() {
  MockFetchTweets fetchTweets;
  MockCollectionReference collectionReference;
  // ignore: close_sinks
  StreamController streamController;
  TimeLineBloc timeLineBloc;

  setUp(() {
    fetchTweets = MockFetchTweets();
    collectionReference = MockCollectionReference();
    streamController = StreamController<QuerySnapshot>();
    timeLineBloc = TimeLineBloc(
      initialState: InitialTimeLineState(),
      fetchTweets: fetchTweets,
    );
  });

  test(('confirm inistial bloc state'), () {
    expect(timeLineBloc.state, equals(InitialTimeLineState()));
  });
  group('timeline bloc test', () {

    test(
        'should emit [FetchingTweet, FetchingComplete] when fetching tweet is successful',
        () async {
      when(collectionReference.snapshots())
          .thenAnswer((_) => streamController.stream);
      when(fetchTweets(NoParams())).thenAnswer(
        (_) => Future.value(
            Right(StreamConverter(collection: collectionReference))),
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
      when(fetchTweets(NoParams())).thenAnswer(
        (_) => Future.value(
            Left(TimeLineFailure(message: 'Failed to load tweets'))),
      );
      final expectations = [
        FetchingTweet(),
        FetchingError(message: 'Failed to load tweets'),
      ];
      expectLater(timeLineBloc, emitsInOrder(expectations));

      timeLineBloc.add(FetchTweet());
    });
  });
}
