import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/domain/usecase/usecases.dart';
import 'package:fc_twitter/features/profile/representation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';

void main() {
  UserProfileEntity userEntity;
  GetUserProfileUseCase getUserProfile;
  UpdateUserProfileUseCase updateUserProfile;
  PickImageUseCase pickImage;
  ProfileBloc profileBloc;

  setUp(() {
    userEntity = userProfileEntityFixture();
    getUserProfile = MockGetUserProfile();
    updateUserProfile = MockUpdateUserProfile();
    pickImage = MockPickImage();
    profileBloc = ProfileBloc(
      getUserProfile: getUserProfile,
      updateUserProfile: updateUserProfile,
      pickImageUseCase: pickImage,
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

  group('profile bloc PickImage event', () {
    test('should emit a [PickedProfileImage] when successful', () async {
      final imageFile = File('image');
      when(pickImage(any)).thenAnswer(
        (_) => Future.value(Right(imageFile)),
      );

      final expectations = [
        PickedProfileImage(pickedProfileImage: imageFile),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(PickImage(imageSource: ImageSource.gallery, isCoverPhoto: false));
    });

    test('should emit a [PickedCoverImage] when successful', () async {
      final imageFile = File('image');
      when(pickImage(any)).thenAnswer(
        (_) => Future.value(Right(imageFile)),
      );

      final expectations = [
        PickedCoverImage(pickedCoverImage: imageFile),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(PickImage(imageSource: ImageSource.gallery, isCoverPhoto: true));
    });

    test('should emit a nothing when unsuccessful', () async {
      when(pickImage(any)).thenAnswer(
        (_) => Future.value(Left(ProfileFilure())),
      );

      final expectations = [];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(PickImage(imageSource: ImageSource.gallery));
    });
  });
}
