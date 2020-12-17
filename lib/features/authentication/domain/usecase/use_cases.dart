import 'package:fc_twitter/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/authentication/domain/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpNewUser implements UseCase<UserCredential, AParams> {
  final UserRepository userRepository;

  SignUpNewUser({this.userRepository});
  @override
  Future<Either<AuthFailure, UserCredential>> call(AParams params) async{
    return await userRepository.signUpNewUser(params.user);
  }
}

class LogInUser implements UseCase<UserCredential, AParams> {
  final UserRepository userRepository;

  LogInUser({this.userRepository});
  @override
  Future<Either<AuthFailure, UserCredential>> call(AParams params) async{
    return await userRepository.logInUser(params.user);
  }
}

class LogOutUser implements UseCase<bool, NoParams> {
  final UserRepository userRepository;

  LogOutUser({this.userRepository});
  @override
  Future<Either<AuthFailure, bool>> call(NoParams params) async{
    return await userRepository.logOutUser();
  }
}

class SaveUserDetail implements UseCase<bool, AParams> {
  final UserRepository userRepository;

  SaveUserDetail({this.userRepository});
  @override
  Future<Either<AuthFailure, bool>> call(AParams params) async{
    return await userRepository.saveUserDetail(params.userProfile);
  }
}