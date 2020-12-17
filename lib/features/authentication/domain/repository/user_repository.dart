
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/authentication/domain/user_entity/user_entity.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {
  Future<Either<AuthFailure, UserCredential>> signUpNewUser(UserEntity user);

  Future<Either<AuthFailure, UserCredential>> logInUser(UserEntity user);

  Future<Either<AuthFailure, bool>> saveUserDetail(UserProfileModel userProfileModel);

  Future<Either<AuthFailure, bool>> logOutUser();
}