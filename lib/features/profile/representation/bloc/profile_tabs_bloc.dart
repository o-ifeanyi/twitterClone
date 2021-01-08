import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/profile/domain/repository/profile_repository.dart.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileTabEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchUserTweets extends ProfileTabEvent {
  final String userId;

  FetchUserTweets({@required this.userId});
}

class FetchUserReplies extends ProfileTabEvent {
  final String userId;

  FetchUserReplies({@required this.userId});
}

class FetchUserMedias extends ProfileTabEvent {
  final String userId;

  FetchUserMedias({@required this.userId});
}

class FetchUserLikes extends ProfileTabEvent {
  final String userId;

  FetchUserLikes({@required this.userId});
}

class ProfileTabState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialProfileTabState extends ProfileTabState {}

class FetchingUserTweets extends ProfileTabState {}

class FetchingUserTweetsComplete extends ProfileTabState {
  final Stream<List<TweetEntity>> content;

  FetchingUserTweetsComplete({this.content});
}

class FetchingUserTweetsFailed extends ProfileTabState {
  final String message;

  FetchingUserTweetsFailed({this.message});
}

class FetchingUserReplies extends ProfileTabState {}

class FetchingUserRepliesComplete extends ProfileTabState {
  final Stream<List<TweetEntity>> content;

  FetchingUserRepliesComplete({this.content});
}

class FetchingUserRepliesFailed extends ProfileTabState {
  final String message;

  FetchingUserRepliesFailed({this.message});
}

class FetchingUserMedias extends ProfileTabState {}

class FetchingUserMediasComplete extends ProfileTabState {
  final Stream<List<TweetEntity>> content;

  FetchingUserMediasComplete({this.content});
}

class FetchingUserMediasFailed extends ProfileTabState {
  final String message;

  FetchingUserMediasFailed({this.message});
}

class FetchingUserLikes extends ProfileTabState {}

class FetchingUserLikesComplete extends ProfileTabState {
  final Stream<List<TweetEntity>> content;

  FetchingUserLikesComplete({this.content});
}

class FetchingUserLikesFailed extends ProfileTabState {
  final String message;

  FetchingUserLikesFailed({this.message});
}

class ProfileTabBloc extends Bloc<ProfileTabEvent, ProfileTabState> {
  final ProfileRepository profileRepository;
  ProfileTabBloc({ProfileTabState initialState, this.profileRepository})
      : super(initialState);

  @override
  Stream<ProfileTabState> mapEventToState(ProfileTabEvent event) async* {
    if (event is FetchUserTweets) {
      yield* _mapFetchUserTweetsToEvent(event.userId);
    }
    if (event is FetchUserReplies) {
      yield* _mapFetchUserRepliesToState(event.userId);
    }
    if (event is FetchUserMedias) {
      yield* _mapFetchUserMediasToState(event.userId);
    }
    if (event is FetchUserLikes) {
      yield* _mapFetchUserLikesToState(event.userId);
    }
  }

  Stream<ProfileTabState> _mapFetchUserTweetsToEvent(String id) async* {
    yield FetchingUserTweets();
    final userTweetsEither = await profileRepository.fetchUserTweets(id);
    yield* userTweetsEither.fold((failure) async* {
      yield FetchingUserTweetsFailed(message: failure.message);
    }, (converter) async* {
      yield FetchingUserTweetsComplete(
          content: converter.fromQuery(converter.query));
    });
  }

  Stream<ProfileTabState> _mapFetchUserRepliesToState(String id) async* {
    yield FetchingUserReplies();
    final userRepliesEither = await profileRepository.fetchUserReplies(id);
    yield* userRepliesEither.fold((failure) async* {
      yield FetchingUserRepliesFailed(message: failure.message);
    }, (converter) async* {
      yield FetchingUserRepliesComplete(
          content: converter.fromQuery(converter.query));
    });
  }

  Stream<ProfileTabState> _mapFetchUserMediasToState(String id) async* {
    yield FetchingUserMedias();
    final userMediasEither = await profileRepository.fetchUserMedias(id);
    yield* userMediasEither.fold((failure) async* {
      yield FetchingUserMediasFailed(message: failure.message);
    }, (converter) async* {
      yield FetchingUserMediasComplete(
          content: converter.fromQuery(converter.query));
    });
  }

  Stream<ProfileTabState> _mapFetchUserLikesToState(String id) async* {
    yield FetchingUserLikes();
    final userLikesEither = await profileRepository.fetchUserLikes(id);
    yield* userLikesEither.fold((failure) async* {
      yield FetchingUserLikesFailed(message: failure.message);
    }, (converter) async* {
      yield FetchingUserLikesComplete(
          content: converter.fromQuery(converter.query));
    });
  }
}
