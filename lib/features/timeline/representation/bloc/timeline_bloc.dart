import 'package:fc_twitter/features/timeline/data/repository/timeline_repository.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/timeline_event.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/timeline_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeLineBloc extends Bloc<TimeLineEvent, TimeLineState> {
  final TimeLineRepositoryImpl repositoryImpl;
  TimeLineBloc({TimeLineState initialState, this.repositoryImpl})
      : super(initialState);

  @override
  Stream<TimeLineState> mapEventToState(TimeLineEvent event) async* {
    if (event is FetchTweet) {
      yield* _mapFetchTweetToState();
    }
    if (event is SendTweet) {
      yield* _mapSendTweetToState(event);
    }
  }

  Stream<TimeLineState> _mapSendTweetToState(TimeLineEvent event) async* {
    yield SendingTweet();
    final sendEither = await repositoryImpl.sendTweet(event.tweet);
    yield* sendEither.fold(
      (failure) async* {
        yield SendingError(message: failure.message);
      },
      (success) async* {
        yield SendingComplete();
      },
    );
  }

  Stream<TimeLineState> _mapFetchTweetToState() async* {
    yield FetchingTweet();
    final sendEither = await repositoryImpl.fetchTweets();
    yield* sendEither.fold(
      (failure) async* {
        yield FetchingError(message: failure.message);
      },
      (stream) async* {
        yield FetchingComplete();
      },
    );
  }
}
