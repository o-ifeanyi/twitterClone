
import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchUserProfile extends ProfileEvent {
  final String userId;

  FetchUserProfile(this.userId);
}

class UpdateUserProfile extends ProfileEvent {
  final UserProfileEntity userEntity;

  UpdateUserProfile(this.userEntity);
}

class PickImage extends ProfileEvent {
  final ImageSource imageSource;
  final bool isCoverPhoto;

  PickImage({this.imageSource, this.isCoverPhoto});
}


