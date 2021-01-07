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
        FetchingContent(),
        FetchingUserTweetsComplete(),
      ];

      expectLater(profileTabBloc, emitsInOrder(expected));
      profileTabBloc.add(FetchUserTweets(userId: userEntity.id));
    });

    test(
        'should emit [FetchingContent, FetchingContentFailed] when successful',
        () async {
      when(mockProfileRepository.fetchUserTweets(userEntity.id)).thenAnswer(
        (_) => Future.value(
            Left(ProfileFailure(message: 'Failed to load user tweets'))),
      );

      final expected = [
        FetchingContent(),
        FetchingUserTweetsFailed(),
      ];

      expectLater(profileTabBloc, emitsInOrder(expected));
      profileTabBloc.add(FetchUserTweets(userId: userEntity.id));
    });
  });
}
