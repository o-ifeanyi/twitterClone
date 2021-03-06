
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/authentication/domain/user_entity/user_entity.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {
  Future<Either<AuthFailure, UserCredential>> signUpNewUser(UserEntity user);

  Future<Either<AuthFailure, UserCredential>> logInUser(UserEntity user);

  Future<Either<AuthFailure, bool>> saveUserDetail(UserProfileEntity userProfileModel);

  Future<Either<AuthFailure, bool>> logOutUser();
}