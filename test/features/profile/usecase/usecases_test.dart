import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/domain/repository/profile_repository.dart.dart';
import 'package:fc_twitter/features/profile/domain/usecase/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';

void main() {
  UserProfileEntity userEntity;
  ProfileRepository profileRepository;
  GetUserProfileUseCase getUserProfile;
  UpdateUserProfileUseCase updateUserProfile;
  PickImageUseCase pickImage;

  setUp(() {
    userEntity = userProfileEntityFixture();
    profileRepository = MockProfileRepository();
    getUserProfile =
        GetUserProfileUseCase(profileRepository: profileRepository);
    updateUserProfile =
        UpdateUserProfileUseCase(profileRepository: profileRepository);
    pickImage = PickImageUseCase(profileRepository: profileRepository);
  });

  group('getUserProfile use case', () {
    test('should return a UserProfileEntity when successful', () async {
      when(profileRepository.getUserProfile(any)).thenAnswer(
        (_) => Future.value(Right(UserProfileEntity())),
      );

      final userProfile = await getUserProfile(PParams(userId: 'test'));

      expect(userProfile, Right(UserProfileEntity()));
      verify(profileRepository.getUserProfile(any));
    });

    test('should return a ProfileFailure when it fails', () async {
      when(profileRepository.getUserProfile(any)).thenAnswer(
        (_) => Future.value(Left(ProfileFilure())),
      );

      final result = await getUserProfile(PParams(userId: 'test'));

      expect(result, Left(ProfileFilure()));
      verify(profileRepository.getUserProfile(any));
    });
  });

  group('updateUserProfile use case', () {
    test('should return a true when successful', () async {
      when(profileRepository.updateUserProfile(any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );

      final userProfile =
          await updateUserProfile(PParams(userEntity: userEntity));

      expect(userProfile, Right(true));
      verify(profileRepository.updateUserProfile(any));
    });

    test('should return a ProfileFailure when it fails', () async {
      when(profileRepository.updateUserProfile(any)).thenAnswer(
        (_) => Future.value(Left(ProfileFilure())),
      );

      final result = await updateUserProfile(PParams(userEntity: userEntity));

      expect(result, Left(ProfileFilure()));
      verify(profileRepository.updateUserProfile(any));
    });
  });

  group('pickImage use case', () {
    test('should return a File when successful', () async {
      final file = File('path');
      when(profileRepository.pickImage(any, any)).thenAnswer(
        (_) => Future.value(Right(file)),
      );

      final result = await pickImage(PParams(source: ImageSource.gallery));

      expect(result, Right(file));
      verify(profileRepository.pickImage(any, any));
    });

    test('should return a ProfileFailure when it fails', () async {
      when(profileRepository.pickImage(any, any)).thenAnswer(
        (_) => Future.value(Left(ProfileFilure())),
      );

      final result = await pickImage(PParams(source: ImageSource.gallery));

      expect(result, Left(ProfileFilure()));
      verify(profileRepository.pickImage(any, any));
    });
  });
}
