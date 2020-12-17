
import 'package:fc_twitter/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/domain/repository/profile_repository.dart.dart';

class GetUserProfileUseCase implements UseCase<UserProfileEntity, PParams>{
  final ProfileRepository profileRepository;

  GetUserProfileUseCase({this.profileRepository});
  @override
  Future<Either<Failure, UserProfileEntity>> call(PParams params) async{
    return await profileRepository.getUserProfile(params.userId);
  }
}

class UpdateUserProfileUseCase implements UseCase<bool, PParams>{
  final ProfileRepository profileRepository;

  UpdateUserProfileUseCase({this.profileRepository});
  @override
  Future<Either<Failure, bool>> call(PParams params) async{
    return await profileRepository.updateUserProfile(params.userEntity);
  }
}