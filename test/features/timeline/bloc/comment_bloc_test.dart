import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/comment_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';

void main() {
  MockCollectionReference collectionReference;
  // ignore: close_sinks
  StreamController streamController;
  CommentBloc commentBloc;
  MockTimeLineRepository mockTimeLineRepository;

  setUp(() {
    collectionReference = MockCollectionReference();
    mockTimeLineRepository = MockTimeLineRepository();
    streamController = StreamController<QuerySnapshot>();
    commentBloc = CommentBloc(
      initialState: InitialCommentState(),
      timeLineRepository: mockTimeLineRepository,
    );
  });

  test(('confirm initial bloc state'), () {
    expect(commentBloc.state, equals(InitialCommentState()));
  });
  group('commentBloc fetchComments event', () {

    test(
        'should emit [FetchingComments, FetchingCommentsComplete] when successful',
        () async {
      when(collectionReference.snapshots())
          .thenAnswer((_) => streamController.stream);
      when(mockTimeLineRepository.fetchComments(any)).thenAnswer(
        (_) => Future.value(
            Right(StreamConverter(query: collectionReference))),
      );

      final expectations = [
        FetchingComments(),
        FetchingCommentsComplete(),
      ];
      expectLater(commentBloc, emitsInOrder(expectations));

      commentBloc.add(FetchComments(tweet: tweetEntityFixture()));
    });

    test(
        'should emit [FetchingComments, FetchingCommentsFailed] when it fails',
        () async {
      when(mockTimeLineRepository.fetchComments(any)).thenAnswer(
        (_) => Future.value(
            Left(TimeLineFailure(message: 'Failed to load comments'))),
      );
      final expectations = [
        FetchingComments(),
        FetchingCommentsError(message: 'Failed to load comments'),
      ];
      expectLater(commentBloc, emitsInOrder(expectations));

      commentBloc.add(FetchComments(tweet: tweetEntityFixture()));
    });
  });
}
