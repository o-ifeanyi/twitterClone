
import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/timeline/domain/repository/timeline_repository.dart.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchComments extends CommentEvent {
  final String tweetId;

  FetchComments({this.tweetId});
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
      yield* _mapFetchCommentsToState(event.tweetId);
    }
  }

  Stream<CommentState> _mapFetchCommentsToState(String id) async* {
    yield FetchingComments();
    final sendEither = await timeLineRepository.fetchComments(id);
    yield* sendEither.fold(
      (failure) async* {
        yield FetchingCommentsError(message: failure.message);
      },
      (converter) async* {
        // converter.toTweetEntity(converter.collection).listen((event) {
        //   print(event);
        // });
        yield FetchingCommentsComplete(
            commentStream: converter.fromCommentQuery(converter.commentQuery));
      },
    );
  }
}