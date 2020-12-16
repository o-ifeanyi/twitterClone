import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';

class ProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileInitialState extends ProfileState {}

class FetchingUserProfile extends ProfileState {}

class FetchingFailed extends ProfileState {}

class FetchingComplete extends ProfileState {
  final UserProfileEntity userProfile;

  FetchingComplete({this.userProfile});
  @override
  List<Object> get props => [userProfile];
}


