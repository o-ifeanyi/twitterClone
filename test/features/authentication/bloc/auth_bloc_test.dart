import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/authentication/data/model/user_model.dart';
import 'package:fc_twitter/features/authentication/data/repository/user_repository.dart';
import 'package:fc_twitter/features/authentication/representation/bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserCredential extends Mock implements UserCredential {}

class MockUserRepositoryImpl extends Mock implements UserRepositoryImpl {}

void main() {
  UserModel userModel;
  AuthBloc authBloc;
  MockUserRepositoryImpl fireBaseUserRepositoryImpl;
  MockUserCredential mockUserCredential;

  setUp(() {
    userModel = UserModel(email: 'ifeanyi@email.com', password: '123456');
    fireBaseUserRepositoryImpl = MockUserRepositoryImpl();
    mockUserCredential = MockUserCredential();
    authBloc = AuthBloc(
        repositoryImpl: fireBaseUserRepositoryImpl,
        initialState: InitialAuthState());
  });

  group('Sign up event', () {
    test(
        'should emit [Authinprogress] and [Authcomplete] when sign up is successful',
        () async {
      when(fireBaseUserRepositoryImpl.signUpNewUser(userModel)).thenAnswer(
        (_) => Future.value(Right(mockUserCredential)),
      );
      when(fireBaseUserRepositoryImpl.saveUserDetail(mockUserCredential))
          .thenAnswer(
        (_) => Future.value(Right(true)),
      );
      final expected = [
        AuthInProgress(),
        AuthComplete(),
      ];
      expectLater(authBloc, emitsInOrder(expected));

      authBloc.add(SignUp(user: userModel));
    });

    test('should emit [Authinprogress] and [Authfailed] when sign up fails',
        () async {
      when(fireBaseUserRepositoryImpl.signUpNewUser(userModel)).thenAnswer(
        (_) => Future.value(Left(AuthFailure(message: 'Sign up failed'))),
      );
      final expected = [
        AuthInProgress(),
        AuthFailed(message: 'Sign up failed'),
      ];
      expectLater(authBloc, emitsInOrder(expected));

      authBloc.add(SignUp(user: userModel));
    });
  });

  group('Log in event', () {
    test(
        'should emit [Authinprogress] and [Authcomplete] when log in is successful',
        () async {
      when(fireBaseUserRepositoryImpl.logInUser(userModel)).thenAnswer(
        (_) => Future.value(Right(mockUserCredential)),
      );
      final expected = [
        AuthInProgress(),
        AuthComplete(),
      ];
      expectLater(authBloc, emitsInOrder(expected));

      authBloc.add(Login(user: userModel));
    });

    test('should emit [Authinprogress] and [Authfailed] when log in fails',
        () async {
      when(fireBaseUserRepositoryImpl.logInUser(userModel)).thenAnswer(
        (_) => Future.value(Left(AuthFailure(message: 'Sign up failed'))),
      );
      final expected = [
        AuthInProgress(),
        AuthFailed(message: 'Sign up failed'),
      ];
      expectLater(authBloc, emitsInOrder(expected));

      authBloc.add(Login(user: userModel));
    });
  });

  group('others', () {
    test(('confirm inistial bloc state'), () {
      expect(authBloc.state, equals(InitialAuthState()));
    });

    test(('confirm log out is called for log out event'), () async {
      authBloc.add(LogOut());
      await untilCalled(fireBaseUserRepositoryImpl.logOutUser());
      verify(fireBaseUserRepositoryImpl.logOutUser());
    });
  });
}
