import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/bloc/profile_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';

void main() {
  UserProfileEntity userEntity;
  MockProfileRepository mockProfileRepository;
  ProfileBloc profileBloc;

  setUp(() {
    userEntity = userProfileEntityFixture();
    mockProfileRepository = MockProfileRepository();
    profileBloc = ProfileBloc(
      initialState: ProfileInitialState(),
      profileRepository: mockProfileRepository,
    );
  });

  test('confirm initial state', () {
    expect(profileBloc.state, equals(ProfileInitialState()));
  });

  group('profile bloc FetchUserProfile event', () {
    test(
        'should emit [FetchingUserProfile and FetchingComplete] when successful',
        () {
      when(mockProfileRepository.getUserProfile(any)).thenAnswer(
        (_) => Future.value(Right(UserProfileEntity())),
      );

      final expectations = [
        FetchingUserProfile(),
        FetchingUserProfileComplete(userProfile: UserProfileEntity()),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(FetchUserProfile('userId'));
    });

    test(
        'should emit [FetchingUserProfile and FetchingFailed] when un-successful',
        () {
      when(mockProfileRepository.getUserProfile(any)).thenAnswer(
        (_) => Future.value(Left(ProfileFailure())),
      );

      final expectations = [
        FetchingUserProfile(),
        FetchingUserProfileFailed(),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(FetchUserProfile('userId'));
    });
  });

  group('profile bloc UpdateUserProfile event', () {
    test(
        'should emit [FetchingUserProfile and FetchingComplete] when successful',
        () {
      when(mockProfileRepository.updateUserProfile(any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );
      when(mockProfileRepository.uploadImage(any)).thenAnswer(
        (_) => Future.value(Right(userEntity)),
      );
      when(mockProfileRepository.getUserProfile(any)).thenAnswer(
        (_) => Future.value(Right(UserProfileEntity())),
      );

      final expectations = [
        FetchingUserProfile(),
        FetchingUserProfileComplete(userProfile: UserProfileEntity()),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(UpdateUserProfile(userEntity));
    });

    test(
        'should emit [FetchingUserProfile and FetchingFailed] when un-successful',
        () {
      when(mockProfileRepository.updateUserProfile(any)).thenAnswer(
        (_) => Future.value(Left(ProfileFailure())),
      );
      when(mockProfileRepository.uploadImage(any)).thenAnswer(
        (_) => Future.value(Right(userEntity)),
      );

      final expectations = [
        UpdateFailed(),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(UpdateUserProfile(userEntity));
    });
  });

  group('profile bloc Follow event', () {
    test(
        'should emit [FetchingUserProfile and FetchingComplete] when successful',
        () {
      when(mockProfileRepository.follow(any, any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );
      when(mockProfileRepository.getUserProfile(any)).thenAnswer(
        (_) => Future.value(Right(UserProfileEntity())),
      );

      final expectations = [
        FetchingUserProfile(),
        FetchingUserProfileComplete(userProfile: UserProfileEntity()),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(Follow(userEntity: userEntity, currentUserEntity: userEntity));
    });

    test(
        'should emit [UpdateFailed] when un-successful',
        () {
      when(mockProfileRepository.follow(any, any)).thenAnswer(
        (_) => Future.value(Left(ProfileFailure())),
      );

      final expectations = [
        UpdateFailed(),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(Follow(userEntity: userEntity, currentUserEntity: userEntity));
    });
  });

  group('profile bloc UnFollow event', () {
    test(
        'should emit [FetchingUserProfile and FetchingComplete] when successful',
        () {
      when(mockProfileRepository.unfollow(any, any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );
      when(mockProfileRepository.getUserProfile(any)).thenAnswer(
        (_) => Future.value(Right(UserProfileEntity())),
      );

      final expectations = [
        FetchingUserProfile(),
        FetchingUserProfileComplete(userProfile: UserProfileEntity()),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(UnFollow(userEntity: userEntity, currentUserEntity: userEntity));
    });

    test(
        'should emit [UpdateFailed] when un-successful',
        () {
      when(mockProfileRepository.unfollow(any, any)).thenAnswer(
        (_) => Future.value(Left(ProfileFailure())),
      );

      final expectations = [
        UpdateFailed(),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(UnFollow(userEntity: userEntity, currentUserEntity: userEntity));
    });
  });
}
