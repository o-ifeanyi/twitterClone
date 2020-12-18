import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/domain/usecase/usecases.dart';
import 'package:fc_twitter/features/profile/representation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';

void main() {
  UserProfileEntity userEntity;
  GetUserProfileUseCase getUserProfile;
  UpdateUserProfileUseCase updateUserProfile;
  ProfileBloc profileBloc;

  setUp(() {
    userEntity = userProfileEntityFixture();
    getUserProfile = MockGetUserProfile();
    updateUserProfile = MockUpdateUserProfile();
    profileBloc = ProfileBloc(
      getUserProfile: getUserProfile,
      updateUserProfile: updateUserProfile,
      initialState: ProfileInitialState(),
    );
  });

  test('confirm initial state', () {
    expect(profileBloc.state, equals(ProfileInitialState()));
  });

  group('profile bloc FetchUserProfile event', () {
    test(
        'should emit [FetchingUserProfile and FetchingComplete] when successful',
        () {
      when(getUserProfile(any)).thenAnswer(
        (_) => Future.value(Right(UserProfileEntity())),
      );

      final expectations = [
        FetchingUserProfile(),
        FetchingComplete(userProfile: UserProfileEntity()),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(FetchUserProfile('userId'));
    });

    test(
        'should emit [FetchingUserProfile and FetchingFailed] when un-successful',
        () {
      when(getUserProfile(any)).thenAnswer(
        (_) => Future.value(Left(ProfileFilure())),
      );

      final expectations = [
        FetchingUserProfile(),
        FetchingFailed(),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(FetchUserProfile('userId'));
    });
  });

  group('profile bloc UpdateUserProfile event', () {
    test(
        'should emit [FetchingUserProfile and FetchingComplete] when successful',
        () {
      when(updateUserProfile(any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );
      when(getUserProfile(any)).thenAnswer(
        (_) => Future.value(Right(UserProfileEntity())),
      );

      final expectations = [
        FetchingUserProfile(),
        FetchingComplete(userProfile: UserProfileEntity()),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(UpdateUserProfile(userEntity));
    });

    test(
        'should emit [FetchingUserProfile and FetchingFailed] when un-successful',
        () {
      when(updateUserProfile(any)).thenAnswer(
        (_) => Future.value(Left(ProfileFilure())),
      );

      final expectations = [
        UpdateFailed(),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(UpdateUserProfile(userEntity));
    });
  });
}
