import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter/material.dart';
import 'package:fc_twitter/features/timeline/domain/repository/timeline_repository.dart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeLineEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchTweet extends TimeLineEvent {}


class TimeLineState extends Equatable {
  @override
  List<Object> get props => [];

  void showSnackBar(
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
    String message,
    int time, {
    bool isError = false,
  }) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: time),
        backgroundColor: isError
            ? Theme.of(context).errorColor
            : Theme.of(context).primaryColor,
      ),
    );
  }
}

class InitialTimeLineState extends TimeLineState {}

class FetchingTweet extends TimeLineState {}

class FetchingTweetError extends TimeLineState {
  final String message;

  FetchingTweetError({this.message});

  @override
  List<Object> get props => [message];
}

class FetchingTweetComplete extends TimeLineState {
  final Stream<List<TweetEntity>> tweetStream;

  FetchingTweetComplete({this.tweetStream});
}

class TimeLineBloc extends Bloc<TimeLineEvent, TimeLineState> {
  final TimeLineRepository timeLineRepository;
  TimeLineBloc({TimeLineState initialState, this.timeLineRepository})
      : super(initialState);

  @override
  Stream<TimeLineState> mapEventToState(TimeLineEvent event) async* {
    if (event is FetchTweet) {
      yield* _mapFetchTweetToState();
    }
  }

  Stream<TimeLineState> _mapFetchTweetToState() async* {
    yield FetchingTweet();
    final sendEither = await timeLineRepository.fetchTweets();
    yield* sendEither.fold(
      (failure) async* {
        yield FetchingTweetError(message: failure.message);
      },
      (converter) async* {
        // converter.toTweetEntity(converter.collection).listen((event) {
        //   print(event);
        // });
        yield FetchingTweetComplete(
            tweetStream: converter.fromCollection(converter.collection));
      },
    );
  }
}
