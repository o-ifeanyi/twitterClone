import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/authentication/domain/user_entity/user_entity.dart';
import 'package:fc_twitter/features/authentication/representation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';

void main() {
  UserEntity userEntity;
  AuthBloc authBloc;
  MockUserCredential mockUserCredential;
  MockUserRepository mockUserRepository;
  MockFireBaseUser fireBaseUser;

  setUp(() {
    userEntity = userEntityFixture();
    fireBaseUser = MockFireBaseUser();
    mockUserCredential = MockUserCredential();
    mockUserRepository = MockUserRepository();
    authBloc = AuthBloc(
      initialState: InitialAuthState(),
      userRepository: mockUserRepository,
    );
  });

  group('Auth bloc Sign up event', () {
    test(
        'should emit [Authinprogress] and [Authcomplete] when sign up and save is successful',
        () async {
      when(mockUserRepository.signUpNewUser(any)).thenAnswer(
        (_) => Future.value(Right(mockUserCredential)),
      );
      when(mockUserCredential.user).thenReturn(fireBaseUser);
      when(fireBaseUser.uid).thenReturn('userId');
      when(mockUserRepository.saveUserDetail(any))
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
      when(mockUserRepository.signUpNewUser(any)).thenAnswer(
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
      when(mockUserRepository.signUpNewUser(any)).thenAnswer(
        (_) => Future.value(Right(mockUserCredential)),
      );
      when(mockUserCredential.user).thenReturn(fireBaseUser);
      when(fireBaseUser.uid).thenReturn('userId');
      when(mockUserRepository.saveUserDetail(any))
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
      when(mockUserRepository.logInUser(any)).thenAnswer(
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
      when(mockUserRepository.logInUser(any)).thenAnswer(
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
      await untilCalled(mockUserRepository.logOutUser());
      verify(mockUserRepository.logOutUser());
    });
  });
}
