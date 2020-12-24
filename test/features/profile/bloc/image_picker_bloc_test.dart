import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/profile/domain/repository/profile_repository.dart.dart';
import 'package:fc_twitter/features/profile/representation/bloc/image_picker_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.dart';

void main() {
  ProfileRepository mockProfileRepository;
  ImagePickerBloc imagePickerBloc;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    imagePickerBloc = ImagePickerBloc(
      initialState: InitialImagePickerState(),
      profileRepository: mockProfileRepository,
    );
  });

  group('imagePicker bloc PickImage event', () {
    test('should emit a [PickedProfileImage] when successful', () async {
      final imageFile = File('image');
      when(mockProfileRepository.pickImage(any, any)).thenAnswer(
        (_) => Future.value(Right(imageFile)),
      );

      final expectations = [
        PickedProfileImage(pickedProfileImage: imageFile),
      ];

      expectLater(imagePickerBloc, emitsInOrder(expectations));
      imagePickerBloc.add(PickImage(imageSource: ImageSource.gallery, isCoverPhoto: false));
    });

    test('should emit a [PickedCoverImage] when successful', () async {
      final imageFile = File('image');
      when(mockProfileRepository.pickImage(any, any)).thenAnswer(
        (_) => Future.value(Right(imageFile)),
      );

      final expectations = [
        PickedCoverImage(pickedCoverImage: imageFile),
      ];

      expectLater(imagePickerBloc, emitsInOrder(expectations));
      imagePickerBloc.add(PickImage(imageSource: ImageSource.gallery, isCoverPhoto: true));
    });

    test('should emit a nothing when unsuccessful', () async {
      when(mockProfileRepository.pickImage(any, any)).thenAnswer(
        (_) => Future.value(Left(ProfileFailure())),
      );

      final expectations = [];

      expectLater(imagePickerBloc, emitsInOrder(expectations));
      imagePickerBloc.add(PickImage(imageSource: ImageSource.gallery));
    });
  });
}
