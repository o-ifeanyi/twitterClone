import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';

class ProfileState extends Equatable {
  final UserProfileEntity userProfile;
  final File pickedProfileImage;
  final File pickedCoverImage;

  ProfileState(
      {this.userProfile, this.pickedProfileImage, this.pickedCoverImage});
  @override
  List<Object> get props => [];
}

class ProfileInitialState extends ProfileState {}

class FetchingUserProfile extends ProfileState {}

class FetchingFailed extends ProfileState {}

class FetchingComplete extends ProfileState {
  final UserProfileEntity userProfile;

  FetchingComplete({this.userProfile}) : super(userProfile: userProfile);
}

class UpdateFailed extends ProfileState {}

class PickedProfileImage extends ProfileState {
  final File pickedProfileImage;

  PickedProfileImage({this.pickedProfileImage})
      : super(pickedProfileImage: pickedProfileImage);
}

class PickedCoverImage extends ProfileState {
  final File pickedCoverImage;

  PickedCoverImage({this.pickedCoverImage})
      : super(pickedCoverImage: pickedCoverImage);
}
