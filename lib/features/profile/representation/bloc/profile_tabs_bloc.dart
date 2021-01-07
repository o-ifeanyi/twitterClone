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

class FetchUserReplies extends ProfileTabEvent {}

class FetchUserMedias extends ProfileTabEvent {}

class FetchUserLikes extends ProfileTabEvent {}

class ProfileTabState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialProfileTabState extends ProfileTabState {}

class FetchingContent extends ProfileTabState {}

class FetchingUserTweetsComplete extends ProfileTabState {
  final Stream<List<TweetEntity>> content;

  FetchingUserTweetsComplete({this.content});
}

class FetchingUserTweetsFailed extends ProfileTabState {
  final String message;

  FetchingUserTweetsFailed({this.message});
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
  }

  Stream<ProfileTabState> _mapFetchUserTweetsToEvent(String id) async* {
    yield FetchingContent();
    final userTweetsEither = await profileRepository.fetchUserTweets(id);
    yield* userTweetsEither.fold((failure) async* {
      yield FetchingUserTweetsFailed(message: failure.message);
    }, (converter) async* {
      yield FetchingUserTweetsComplete(
          content: converter.fromQuery(converter.query));
    });
  }
}
