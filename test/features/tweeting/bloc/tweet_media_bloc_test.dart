import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/tweeting/representation/bloc/tweet_media_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.dart';

void main() {
  MockTweetingRepository mockTweetingRepository;
  TweetMediaBloc tweetMediaBloc;

  setUp(() {
    mockTweetingRepository = MockTweetingRepository();
    tweetMediaBloc = TweetMediaBloc(
      initialState: InitialMediaState(),
      tweetingRepository: mockTweetingRepository,
    );
  });

  test(('confirm inistial bloc state'), () {
    expect(tweetMediaBloc.state, equals(InitialMediaState()));
  });

  group('tweetMedia bloc PickMultiImages Event', () {
    test('should emit [InitialMediaState, MultiImagesLoaded] when successful',
        () async {
      when(mockTweetingRepository.pickImages()).thenAnswer(
        (_) => Future.value(Right([])),
      );

      final expectations = [
        InitialMediaState(),
        MultiImagesLoaded(),
      ];
      expectLater(tweetMediaBloc, emitsInOrder(expectations));

      tweetMediaBloc.add(PickMultiImages());
    });

    test('should emit [InitialMediaState] when it fails',
        () async {
      when(mockTweetingRepository.pickImages()).thenAnswer(
        (_) => Future.value(Left(TweetingFailure())),
      );

      final expectations = [
        InitialMediaState(),
      ];
      expectLater(tweetMediaBloc, emitsInOrder(expectations));

      tweetMediaBloc.add(PickMultiImages());
    });
  });
}
