import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/bloc/profile_tabs_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';

void main() {
  UserProfileEntity userEntity;
  // ignore: close_sinks
  StreamController streamController;
  MockCollectionReference collectionReference;
  MockProfileRepository mockProfileRepository;
  ProfileTabBloc profileTabBloc;

  setUp(() {
    userEntity = userProfileEntityFixture();
    collectionReference = MockCollectionReference();
    mockProfileRepository = MockProfileRepository();
    streamController = StreamController<QuerySnapshot>();
    profileTabBloc = ProfileTabBloc(
      initialState: InitialProfileTabState(),
      profileRepository: mockProfileRepository,
    );
  });

  test('confirm initial state', () {
    expect(profileTabBloc.state, equals(InitialProfileTabState()));
  });

  group('profileTab bloc FetchUserTweet event', () {
    test(
        'should emit [FetchingContent, FetchingContentComplete] when successful',
        () async {
      when(collectionReference.snapshots())
          .thenAnswer((_) => streamController.stream);
      when(mockProfileRepository.fetchUserTweets(userEntity.id)).thenAnswer(
        (_) => Future.value(
            Right(StreamConverter(query: collectionReference))),
      );

      final expected = [
        FetchingUserTweets(),
        FetchingUserTweetsComplete(),
      ];

      expectLater(profileTabBloc, emitsInOrder(expected));
      profileTabBloc.add(FetchUserTweets(userId: userEntity.id));
    });

    test(
        'should emit [FetchingUserTweets, FetchingUserTweetsFailed] when successful',
        () async {
      when(mockProfileRepository.fetchUserTweets(userEntity.id)).thenAnswer(
        (_) => Future.value(
            Left(ProfileFailure(message: 'Failed to load user tweets'))),
      );

      final expected = [
        FetchingUserTweets(),
        FetchingUserTweetsFailed(),
      ];

      expectLater(profileTabBloc, emitsInOrder(expected));
      profileTabBloc.add(FetchUserTweets(userId: userEntity.id));
    });
  });

  group('profileTab bloc FetchUserReplies event', () {
    test(
        'should emit [FetchingUserReplies, FetchingUserRepliesComplete] when successful',
        () async {
      when(collectionReference.snapshots())
          .thenAnswer((_) => streamController.stream);
      when(mockProfileRepository.fetchUserReplies(userEntity.id)).thenAnswer(
        (_) => Future.value(
            Right(StreamConverter(query: collectionReference))),
      );

      final expected = [
        FetchingUserReplies(),
        FetchingUserRepliesComplete(),
      ];

      expectLater(profileTabBloc, emitsInOrder(expected));
      profileTabBloc.add(FetchUserReplies(userId: userEntity.id));
    });

    test(
        'should emit [FetchingUserReplies, FetchingUserRepliesFailed] when successful',
        () async {
      when(mockProfileRepository.fetchUserReplies(userEntity.id)).thenAnswer(
        (_) => Future.value(
            Left(ProfileFailure(message: 'Failed to load user replies'))),
      );

      final expected = [
        FetchingUserReplies(),
        FetchingUserRepliesFailed(),
      ];

      expectLater(profileTabBloc, emitsInOrder(expected));
      profileTabBloc.add(FetchUserReplies(userId: userEntity.id));
    });
  });

  group('profileTab bloc FetchUserMedias event', () {
    test(
        'should emit [FetchingUserMedias, FetchingUserMediasComplete] when successful',
        () async {
      when(collectionReference.snapshots())
          .thenAnswer((_) => streamController.stream);
      when(mockProfileRepository.fetchUserMedias(userEntity.id)).thenAnswer(
        (_) => Future.value(
            Right(StreamConverter(query: collectionReference))),
      );

      final expected = [
        FetchingUserMedias(),
        FetchingUserMediasComplete(),
      ];

      expectLater(profileTabBloc, emitsInOrder(expected));
      profileTabBloc.add(FetchUserMedias(userId: userEntity.id));
    });

    test(
        'should emit [FetchingUserMedias, FetchingUserMediasFailed] when successful',
        () async {
      when(mockProfileRepository.fetchUserMedias(userEntity.id)).thenAnswer(
        (_) => Future.value(
            Left(ProfileFailure(message: 'Failed to load user medias'))),
      );

      final expected = [
        FetchingUserMedias(),
        FetchingUserMediasFailed(),
      ];

      expectLater(profileTabBloc, emitsInOrder(expected));
      profileTabBloc.add(FetchUserMedias(userId: userEntity.id));
    });
  });

  group('profileTab bloc FetchUserLikes event', () {
    test(
        'should emit [FetchingUserLikes, FetchingUserLikesComplete] when successful',
        () async {
      when(collectionReference.snapshots())
          .thenAnswer((_) => streamController.stream);
      when(mockProfileRepository.fetchUserLikes(userEntity.id)).thenAnswer(
        (_) => Future.value(
            Right(StreamConverter(query: collectionReference))),
      );

      final expected = [
        FetchingUserLikes(),
        FetchingUserLikesComplete(),
      ];

      expectLater(profileTabBloc, emitsInOrder(expected));
      profileTabBloc.add(FetchUserLikes(userId: userEntity.id));
    });

    test(
        'should emit [FetchingUserLikes, FetchingUserLikesFailed] when successful',
        () async {
      when(mockProfileRepository.fetchUserLikes(userEntity.id)).thenAnswer(
        (_) => Future.value(
            Left(ProfileFailure(message: 'Failed to load user likes'))),
      );

      final expected = [
        FetchingUserLikes(),
        FetchingUserLikesFailed(),
      ];

      expectLater(profileTabBloc, emitsInOrder(expected));
      profileTabBloc.add(FetchUserLikes(userId: userEntity.id));
    });
  });
}
