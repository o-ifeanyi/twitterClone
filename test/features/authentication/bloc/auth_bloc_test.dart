import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/authentication/domain/usecase/use_cases.dart';
import 'package:fc_twitter/features/authentication/domain/user_entity/user_entity.dart';
import 'package:fc_twitter/features/authentication/representation/bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserCredential extends Mock implements UserCredential {}

class MockSignUpNewUser extends Mock implements SignUpNewUser {}

class MockSaveUserDetail extends Mock implements SaveUserDetail {}

class MockLogInUser extends Mock implements LogInUser {}

class MockLogOutUser extends Mock implements LogOutUser {}

void main() {
  UserEntity user;
  AuthBloc authBloc;
  MockSignUpNewUser signUpNewUser;
  MockSaveUserDetail saveUserDetail;
  MockLogInUser logInUser;
  MockLogOutUser logOutUser;
  MockUserCredential mockUserCredential;

  setUp(() {
    user = UserEntity(email: 'ifeanyi@email.com', password: '123456');
    signUpNewUser = MockSignUpNewUser();
    saveUserDetail = MockSaveUserDetail();
    logInUser = MockLogInUser();
    logOutUser = MockLogOutUser();
    mockUserCredential = MockUserCredential();
    authBloc = AuthBloc(
      initialState: InitialAuthState(),
      signUpNewUser: signUpNewUser,
      saveUserDetail: saveUserDetail,
      logInUser: logInUser,
      logOutUser: logOutUser,
    );
  });

  group('Sign up event', () {
    test(
        'should emit [Authinprogress] and [Authcomplete] when sign up and save is successful',
        () async {
      when(signUpNewUser(any)).thenAnswer(
        (_) => Future.value(Right(mockUserCredential)),
      );
      when(saveUserDetail(any))
          .thenAnswer(
        (_) => Future.value(Right(true)),
      );
      final expected = [
        AuthInProgress(),
        AuthComplete(),
      ];
      expectLater(authBloc, emitsInOrder(expected));

      authBloc.add(SignUp(user: user));
    });

    test('should emit [Authinprogress] and [Authfailed] when sign up fails',
        () async {
      when(signUpNewUser(any)).thenAnswer(
        (_) => Future.value(Left(AuthFailure(message: 'Sign up failed'))),
      );
      final expected = [
        AuthInProgress(),
        AuthFailed(message: 'Sign up failed'),
      ];
      expectLater(authBloc, emitsInOrder(expected));

      authBloc.add(SignUp(user: user));
    });

    test('should emit [AuthFailed] when user details fails to save', () async {
      when(signUpNewUser(any)).thenAnswer(
        (_) => Future.value(Right(mockUserCredential)),
      );
      when(saveUserDetail(any))
          .thenAnswer(
        (_) =>
            Future.value(Left(AuthFailure(message: 'Saving details failed'))),
      );
      final expected = [
        AuthInProgress(),
        AuthFailed(message: 'Saving details failed'),
      ];
      expectLater(authBloc, emitsInOrder(expected));

      authBloc.add(SignUp(user: user));
    });
  });

  group('Log in event', () {
    test(
        'should emit [Authinprogress] and [Authcomplete] when log in is successful',
        () async {
      when(logInUser(any)).thenAnswer(
        (_) => Future.value(Right(mockUserCredential)),
      );
      final expected = [
        AuthInProgress(),
        AuthComplete(),
      ];
      expectLater(authBloc, emitsInOrder(expected));

      authBloc.add(Login(user: user));
    });

    test('should emit [Authinprogress] and [Authfailed] when log in fails',
        () async {
      when(logInUser(any)).thenAnswer(
        (_) => Future.value(Left(AuthFailure(message: 'Sign up failed'))),
      );
      final expected = [
        AuthInProgress(),
        AuthFailed(message: 'Sign up failed'),
      ];
      expectLater(authBloc, emitsInOrder(expected));

      authBloc.add(Login(user: user));
    });
  });

  group('others', () {
    test(('confirm inistial bloc state'), () {
      expect(authBloc.state, equals(InitialAuthState()));
    });

    test(('confirm log out is called for log out event'), () async {
      authBloc.add(LogOut());
      await untilCalled(logOutUser(NoParams()));
      verify(logOutUser(NoParams()));
    });
  });
}
