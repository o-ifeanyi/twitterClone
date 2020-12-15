import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/timeline/domain/usecase/usecases.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/bloc.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/timeline_event.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/timeline_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeLineBloc extends Bloc<TimeLineEvent, TimeLineState> {
  final FetchTweetUseCase fetchTweets;
  TimeLineBloc({TimeLineState initialState, this.fetchTweets})
      : super(initialState);

  @override
  Stream<TimeLineState> mapEventToState(TimeLineEvent event) async* {
    if (event is FetchTweet) {
      yield* _mapFetchTweetToState();
    }
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
