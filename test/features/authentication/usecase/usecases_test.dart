import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/authentication/domain/usecase/use_cases.dart';
import 'package:fc_twitter/features/authentication/domain/user_entity/user_entity.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.dart';



void main() {
  UserProfileModel userProfileModel;
  SignUpNewUser signUpNewUser;
  SaveUserDetail saveUserDetail;
  LogInUser logInUser;
  LogOutUser logOutUser;
  MockUserCredential userCredential;
  UserEntity userEntity;
  MockUserRepository userRepository;

  setUp(() {
    userEntity = UserEntity(email: 'ifeanyi@email.com', password: '123456');
    userProfileModel = UserProfileModel(id: '001', name: 'ifeanyi', userName: 'onuoha');
    userCredential = MockUserCredential();
    userRepository = MockUserRepository();
    signUpNewUser = SignUpNewUser(userRepository: userRepository);
    saveUserDetail = SaveUserDetail(userRepository: userRepository);
    logInUser = LogInUser(userRepository: userRepository);
    logOutUser = LogOutUser(userRepository: userRepository);
  });

  group('use case', () {
    test('should return usercredential from repository on signup', () async{
      when(userRepository.signUpNewUser(userEntity)).thenAnswer(
        (_) => Future.value(Right(userCredential)),
      );

      final result = await signUpNewUser(AParams(user: userEntity));

      expect(result, Right(userCredential));
      verify(userRepository.signUpNewUser(any));
    });

     test('should return usercredential from repository on login', () async{
      when(userRepository.logInUser(userEntity)).thenAnswer(
        (_) => Future.value(Right(userCredential)),
      );

      final result = await logInUser(AParams(user: userEntity));

      expect(result, Right(userCredential));
      verify(userRepository.logInUser(any));
    });

    test('should return true from repository on saving user detail', () async{
      when(userRepository.saveUserDetail(userProfileModel)).thenAnswer(
        (_) => Future.value(Right(true)),
      );

      final result = await saveUserDetail(AParams(userProfile: userProfileModel));

      expect(result, Right(true));
      verify(userRepository.saveUserDetail(any));
    });

    test('should return AuthFailure from repository on signup fail', () async{
     when(userRepository.signUpNewUser(userEntity)).thenAnswer(
        (_) => Future.value(Left(AuthFailure())),
      );

      final result = await signUpNewUser(AParams(user: userEntity));

      expect(result, Left(AuthFailure()));
      verify(userRepository.signUpNewUser(any));
    });

    test('should return AuthFailure from repository on login fail', () async{
     when(userRepository.logInUser(userEntity)).thenAnswer(
        (_) => Future.value(Left(AuthFailure())),
      );

      final result = await logInUser(AParams(user: userEntity));

      expect(result, Left(AuthFailure()));
      verify(userRepository.logInUser(any));
    });

    test('should return AuthFailure from repository on saving detail fail', () async{
     when(userRepository.saveUserDetail(userProfileModel)).thenAnswer(
        (_) => Future.value(Left(AuthFailure())),
      );

      final result = await saveUserDetail(AParams(userProfile: userProfileModel));

      expect(result, Left(AuthFailure()));
      verify(userRepository.saveUserDetail(any));
    });

    test('should return true from repository on log out success', () async{
     when(userRepository.logOutUser()).thenAnswer(
        (_) => Future.value(Right(true)),
      );

      final result = await logOutUser(NoParams());

      expect(result, Right(true));
      verify(userRepository.logOutUser());
    });

    test('should return AuthFailure from repository on logot fail', () async{
     when(userRepository.logOutUser()).thenAnswer(
        (_) => Future.value(Left(AuthFailure())),
      );

      final result = await logOutUser(NoParams());

      expect(result, Left(AuthFailure()));
      verify(userRepository.logOutUser());
    });
  });
}
