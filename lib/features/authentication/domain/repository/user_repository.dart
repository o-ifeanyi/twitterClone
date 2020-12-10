
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/authentication/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {
  Future<Either<Failure, UserCredential>> signUpNewUser(UserModel user);

  Future<Either<Failure, UserCredential>> logInUser(UserModel user);

  Future<Either<Failure, bool>> saveUserDetail(UserCredential credential);

  void logOutUser();
}