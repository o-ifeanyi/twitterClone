
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<ProfileFilure, UserProfileEntity>> getUserProfile(String userId);
}