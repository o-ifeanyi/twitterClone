
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/profile/domain/repository/profile_repository.dart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PickImage extends ImagePickerEvent {
  final ImageSource imageSource;
  final bool isCoverPhoto;

  PickImage({this.imageSource, this.isCoverPhoto});
}

class ImagePickerState extends Equatable {
  final File pickedProfileImage;
  final File pickedCoverImage;

  ImagePickerState({this.pickedProfileImage, this.pickedCoverImage});
  @override
  List<Object> get props => [pickedProfileImage, pickedCoverImage];
}

class InitialImagePickerState extends ImagePickerState {}

class PickedProfileImage extends ImagePickerState {
  final File pickedProfileImage;

  PickedProfileImage({this.pickedProfileImage}) : super(pickedProfileImage: pickedProfileImage);
}

class PickedCoverImage extends ImagePickerState {
  final File pickedCoverImage;

  PickedCoverImage({this.pickedCoverImage}) : super(pickedCoverImage: pickedCoverImage);
}

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  final ProfileRepository profileRepository;
  ImagePickerBloc({ImagePickerState initialState, this.profileRepository}) : super(initialState);

  @override
  Stream<ImagePickerState> mapEventToState(ImagePickerEvent event) async*{
    if (event is PickImage) {
      yield* _mapPickImageToEvent(event.imageSource, event.isCoverPhoto);
    }
  }

  Stream<ImagePickerState> _mapPickImageToEvent(
      ImageSource source, bool isCoverPhoto) async* {
    final imageEither = await profileRepository.pickImage(source, isCoverPhoto);
    yield* imageEither.fold((failure) async* {
      print('nothing');
    }, (image) async* {
      yield isCoverPhoto
          ? PickedCoverImage(pickedCoverImage: image)
          : PickedProfileImage(pickedProfileImage: image);
    });
  }
}