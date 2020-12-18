import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/authentication/domain/user_entity/user_entity.dart';
import 'package:fc_twitter/features/authentication/representation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';

void main() {
  UserEntity userEntity;
  AuthBloc authBloc;
  MockSignUpNewUser signUpNewUser;
  MockSaveUserDetail saveUserDetail;
  MockLogInUser logInUser;
  MockLogOutUser logOutUser;
  MockUserCredential mockUserCredential;
  MockFireBaseUser fireBaseUser;

  setUp(() {
    userEntity = userEntityFixture();
    fireBaseUser = MockFireBaseUser();
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

  group('Auth bloc Sign up event', () {
    test(
        'should emit [Authinprogress] and [Authcomplete] when sign up and save is successful',
        () async {
      when(signUpNewUser(any)).thenAnswer(
        (_) => Future.value(Right(mockUserCredential)),
      );
      when(mockUserCredential.user).thenReturn(fireBaseUser);
      when(fireBaseUser.uid).thenReturn('userId');
      when(saveUserDetail(any))
          .thenAnswer(
        (_) => Future.value(Right(true)),
      );
      final expected = [
        AuthInProgress(),
        AuthComplete(),
      ];
      expectLater(authBloc, emitsInOrder(expected));

      authBloc.add(SignUp(user: userEntity));
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

      authBloc.add(SignUp(user: userEntity));
    });

    test('should emit [AuthFailed] when user details fails to save', () async {
      when(signUpNewUser(any)).thenAnswer(
        (_) => Future.value(Right(mockUserCredential)),
      );
      when(mockUserCredential.user).thenReturn(fireBaseUser);
      when(fireBaseUser.uid).thenReturn('userId');
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

      authBloc.add(SignUp(user: userEntity));
    });
  });

  group('Auth bloc Log in event', () {
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

      authBloc.add(Login(user: userEntity));
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

      authBloc.add(Login(user: userEntity));
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
