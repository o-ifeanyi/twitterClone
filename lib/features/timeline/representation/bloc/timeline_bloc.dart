import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/timeline/data/repository/timeline_repository.dart';
import 'package:fc_twitter/features/timeline/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/timeline/domain/usecase/usecases.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/bloc.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/timeline_event.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/timeline_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeLineBloc extends Bloc<TimeLineEvent, TimeLineState> {
  final FetchTweetUseCase fetchTweets;
  final SendTweetUseCase sendTweet;
  TimeLineBloc({TimeLineState initialState, this.fetchTweets, this.sendTweet})
      : super(initialState);

  @override
  Stream<TimeLineState> mapEventToState(TimeLineEvent event) async* {
    if (event is FetchTweet) {
      yield* _mapFetchTweetToState();
    }
    if (event is SendTweet) {
      yield* _mapSendTweetToState(event.tweet);
    }
  }

  Stream<TimeLineState> _mapSendTweetToState(TweetEntity tweet) async* {
    final sendEither = await sendTweet(TParams(tweet: tweet));
    yield* sendEither.fold(
      (failure) async* {
        yield SendingError(message: failure.message);
      },
      (success) async* {
        yield SendingComplete();
      },
    );
    yield* _mapFetchTweetToState();
  }

  Stream<TimeLineState> _mapFetchTweetToState() async* {
    yield FetchingTweet();
    final sendEither = await fetchTweets(NoParams());
    yield* sendEither.fold(
      (failure) async* {
        yield FetchingError(message: failure.message);
      },
      (converter) async* {
        yield FetchingComplete(tweetStream: converter.toTweetEntity(converter.collection));
      },
    );
  }
}
