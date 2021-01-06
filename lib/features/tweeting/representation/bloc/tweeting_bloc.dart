import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/domain/repository/tweeting_repository.dart';
import 'package:fc_twitter/features/tweeting/representation/bloc/tweeting_event.dart';
import 'package:fc_twitter/features/tweeting/representation/bloc/tweeting_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class TweetingBloc extends Bloc<TweetingEvent, TweetingState> {
  final TweetingRepository tweetingRepository;
  TweetingBloc({TweetingState initialState, this.tweetingRepository})
      : super(initialState);

  @override
  Stream<TweetingState> mapEventToState(TweetingEvent event) async* {
    if (event is SendTweet) {
      yield* _mapSendTweetToState(event.userProfile, event.tweet);
    }
    if (event is LikeTweet) {
      yield* _mapLikeTweetToState(event.userProfile, event.tweet);
    }
    if (event is UnlikeTweet) {
      yield* _mapUnlikeTweetToState(event.userProfile, event.tweet);
    }
    if (event is Retweet) {
      yield* _mapRetweetToState(event.userProfile, event.tweet);
    }
    if (event is UndoRetweet) {
      yield* _mapUndoRetweetToState(event.userProfile, event.tweet);
    }
    if (event is Comment) {
      yield* _mapCommentToState(event.userProfile, event.tweet, event.comment);
    }
  }

  Stream<TweetingState> _mapSendTweetToState(
      UserProfileEntity userProfile, TweetEntity tweet) async* {
    if (tweet.hasMedia && tweet.images[0].runtimeType == Asset) {
      final imageLinks = await tweetingRepository.uploadImages(tweet.images);
      yield* imageLinks.fold((failure) async* {
        yield TweetingError(message: failure.message);
      }, (imageLinks) async* {
        tweet = tweet.copyWith(images: imageLinks);
      });
    }
    final sendEither = await tweetingRepository.sendTweet(userProfile, tweet);
    yield* sendEither.fold(
      (failure) async* {
        yield TweetingError(message: failure.message);
      },
      (success) async* {
        yield TweetingComplete();
      },
    );
  }

  Stream<TweetingState> _mapLikeTweetToState(
      UserProfileEntity userProfile, TweetEntity tweet) async* {
    final likeEither = await tweetingRepository.likeTweet(userProfile, tweet);
    yield* likeEither.fold(
      (failure) async* {
        yield TweetingError(message: failure.message);
      },
      (success) async* {
        yield TweetingComplete();
      },
    );
  }

  Stream<TweetingState> _mapUnlikeTweetToState(
      UserProfileEntity userProfile, TweetEntity tweet) async* {
    final likeEither = await tweetingRepository.unlikeTweet(userProfile, tweet);
    yield* likeEither.fold(
      (failure) async* {
        yield TweetingError(message: failure.message);
      },
      (success) async* {
        yield TweetingComplete();
      },
    );
  }

  Stream<TweetingState> _mapRetweetToState(
      UserProfileEntity userProfile, TweetEntity tweet) async* {
    final retweetEither = await tweetingRepository.retweet(userProfile, tweet);
    yield* retweetEither.fold(
      (failure) async* {
        yield TweetingError(message: failure.message);
      },
      (success) async* {
        yield TweetingComplete();
      },
    );
  }

  Stream<TweetingState> _mapUndoRetweetToState(
      UserProfileEntity userProfile, TweetEntity tweet) async* {
    final retweetEither =
        await tweetingRepository.undoRetweet(userProfile, tweet);
    yield* retweetEither.fold(
      (failure) async* {
        yield TweetingError(message: failure.message);
      },
      (success) async* {
        // Delete tweet
        yield TweetingComplete();
      },
    );
  }

  Stream<TweetingState> _mapCommentToState(UserProfileEntity userProfile,
      TweetEntity tweet, TweetEntity comment) async* {
    final retweetEither = await tweetingRepository.comment(
        userProfile: userProfile, tweet: tweet, commentTweet: comment);
    yield* retweetEither.fold(
      (failure) async* {
        yield TweetingError(message: failure.message);
      },
      (success) async* {
        // Delete tweet
        yield TweetingComplete();
      },
    );
  }
}
