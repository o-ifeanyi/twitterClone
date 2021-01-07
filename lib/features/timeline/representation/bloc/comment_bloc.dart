
import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/timeline/domain/repository/timeline_repository.dart.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchComments extends CommentEvent {
  final TweetEntity tweet;

  FetchComments({this.tweet});
}

class CommentState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialCommentState extends CommentState {}

class FetchingComments extends CommentState {}

class FetchingCommentsError extends CommentState {
  final String message;

  FetchingCommentsError({this.message});

  @override
  List<Object> get props => [message];
}

class FetchingCommentsComplete extends CommentState {
  final Stream<List<TweetEntity>> commentStream;

  FetchingCommentsComplete({this.commentStream});
}

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final TimeLineRepository timeLineRepository;
  CommentBloc({CommentState initialState, this.timeLineRepository}) : super(initialState);

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async*{
    if (event is FetchComments) {
      yield* _mapFetchCommentsToState(event.tweet);
    }
  }

  Stream<CommentState> _mapFetchCommentsToState(TweetEntity tweet) async* {
    yield FetchingComments();
    final sendEither = await timeLineRepository.fetchComments(tweet);
    yield* sendEither.fold(
      (failure) async* {
        yield FetchingCommentsError(message: failure.message);
      },
      (converter) async* {
        // converter.fromCommentQuery(converter.commentQuery).listen((event) {
        //   print(event);
        // });
        yield FetchingCommentsComplete(
            commentStream: converter.fromQuery(converter.query));
      },
    );
  }
}