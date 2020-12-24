import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/domain/repository/tweeting_repository.dart';
import 'package:fc_twitter/features/tweeting/representation/bloc/tweeting_event.dart';
import 'package:fc_twitter/features/tweeting/representation/bloc/tweeting_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TweetingBloc extends Bloc<TweetingEvent, TweetingState> {
  final TweetingRepository tweetingRepository;
  TweetingBloc({TweetingState initialState, this.tweetingRepository})
      : super(initialState);

  @override
  Stream<TweetingState> mapEventToState(TweetingEvent event) async* {
    if (event is SendTweet) {
      yield* _mapSendTweetToState(event.tweet);
    }
    if (event is LikeOrUnlikeTweet) {
      yield* _mapLikeOrUnlikeToState(event.userProfile, event.tweet);
    }
  }

  Stream<TweetingState> _mapSendTweetToState(TweetEntity tweet) async* {
    final sendEither = await tweetingRepository.sendTweet(tweet);
    yield* sendEither.fold(
      (failure) async* {
        yield TweetingError(message: failure.message);
      },
      (success) async* {
        yield TweetingComplete();
      },
    );
  }

  Stream<TweetingState> _mapLikeOrUnlikeToState(
      UserProfileEntity userProfile, TweetEntity tweet) async* {
    final likeEither =
        await tweetingRepository.likeOrUnlikeTweet(userProfile, tweet);
    yield* likeEither.fold(
      (failure) async* {
        yield TweetingError(message: failure.message);
      },
      (success) async* {
        yield TweetingComplete();
      },
    );
  }
}
