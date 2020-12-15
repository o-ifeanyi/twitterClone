import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/representation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.dart';

void main() {
  TweetEntity tweetEntity;
  MockSendTweet sendTweet;
  // MockFetchTweets fetchTweets;
  MockCollectionReference collectionReference;
  // ignore: close_sinks
  StreamController streamController;
  TweetingBloc tweetingBloc;

  setUp(() {
    tweetEntity = TweetEntity(
      name: 'ifeanyi',
      userName: 'onuoha',
      message: 'hello world, testing',
      timeStamp: Timestamp.now(),
    );
    sendTweet = MockSendTweet();
    // fetchTweets = MockFetchTweets();
    collectionReference = MockCollectionReference();
    streamController = StreamController<QuerySnapshot>();
    tweetingBloc = TweetingBloc(
      initialState: InitialTweetingState(),
      sendTweet: sendTweet,
    );
  });

  test(('confirm inistial bloc state'), () {
    expect(tweetingBloc.state, equals(InitialTweetingState()));
  });

  void setUpFetchSuccess() {
    when(collectionReference.snapshots())
        .thenAnswer((_) => streamController.stream);
    // when(fetchTweets(NoParams())).thenAnswer(
    //   (_) =>
    //       Future.value(Right(StreamConverter(collection: collectionReference))),
    // );
  }

  group('timeline bloc test', () {
    test('should emit [SendingComplete] first when tweet is sent successfully',
        () async {
      when(sendTweet(any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );
      setUpFetchSuccess();

      final expectations = [
        SendingComplete(),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc.add(SendTweet(tweet: tweetEntity));
    });

    test('should emit [SendingError] first when sending tweet fails', () async {
      when(sendTweet(any)).thenAnswer(
        (_) => Future.value(
            Left(TweetingFailure(message: 'Failed to send tweet'))),
      );
      setUpFetchSuccess();

      final expectations = [
        SendingError(message: 'Failed to send tweet'),
      ];
      expectLater(tweetingBloc, emitsInOrder(expectations));

      tweetingBloc.add(SendTweet(tweet: tweetEntity));
    });

    // test(
    //     'should emit [FetchingTweet, FetchingComplete] when fetching tweet is successful',
    //     () async {
    //   when(collectionReference.snapshots())
    //       .thenAnswer((_) => streamController.stream);
    //   when(fetchTweets(NoParams())).thenAnswer(
    //     (_) => Future.value(
    //         Right(StreamConverter(collection: collectionReference))),
    //   );

    //   final expectations = [
    //     FetchingTweet(),
    //     FetchingComplete(),
    //   ];
    //   expectLater(tweetingBloc, emitsInOrder(expectations));

    //   tweetingBloc.add(FetchTweet());
    // });

    // test(
    //     'should emit [FetchingTweet, FetchingFailed] when fetching tweet fails',
    //     () async {
    //   when(fetchTweets(NoParams())).thenAnswer(
    //     (_) => Future.value(
    //         Left(TimeLineFailure(message: 'Failed to load tweets'))),
    //   );
    //   final expectations = [
    //     FetchingTweet(),
    //     FetchingError(message: 'Failed to load tweets'),
    //   ];
    //   expectLater(tweetingBloc, emitsInOrder(expectations));

    //   tweetingBloc.add(FetchTweet());
    // });
  });
}
