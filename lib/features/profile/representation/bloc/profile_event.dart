
import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';

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


