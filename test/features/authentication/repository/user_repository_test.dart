import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/authentication/data/model/user_model.dart';
import 'package:fc_twitter/features/authentication/data/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFireBaseAuth extends Mock implements FirebaseAuth {}

class MockFireBaseFirestore extends Mock implements FirebaseFirestore {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  UserModel userModel;
  MockFireBaseAuth mockFireBaseAuth;
  MockFireBaseFirestore mockFireBaseFirestore;
  MockUserCredential mockUserCredential;
  UserRepositoryImpl fireBaseUserRepositoryImpl;

  setUp(() {
    userModel = UserModel(email: 'ifeanyi@email.com', password: '123456');
    mockFireBaseAuth = MockFireBaseAuth();
    mockUserCredential = MockUserCredential();
    mockFireBaseFirestore = MockFireBaseFirestore();
    fireBaseUserRepositoryImpl = UserRepositoryImpl(
        firebaseAuth: mockFireBaseAuth,
        firebaseFirestore: mockFireBaseFirestore);
  });

  group('user authentication', () {
    test('should return a new user when signing up is successful', () async {
      when(mockFireBaseAuth.createUserWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer(
        (_) => Future.value(mockUserCredential),
      );
      final user = await fireBaseUserRepositoryImpl.signUpNewUser(userModel);

      expect(user, equals(Right(mockUserCredential)));
    });

    test('should return a signup failure when error occurs during sign up',
        () async {
      when(mockFireBaseAuth.createUserWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(Error());
      final user = await fireBaseUserRepositoryImpl.signUpNewUser(userModel);

      expect(user, equals(Left(AuthFailure(message: 'Sign up failed'))));
    });

    test('should return a new user when loging in succesful', () async {
      when(mockFireBaseAuth.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer(
        (_) => Future.value(mockUserCredential),
      );
      final user = await fireBaseUserRepositoryImpl.logInUser(userModel);

      expect(user, equals(Right(mockUserCredential)));
    });

    test('should return a login failure when error occurs during login',
        () async {
      when(mockFireBaseAuth.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(Error());

      final user = await fireBaseUserRepositoryImpl.logInUser(userModel);
      print('user ==>  $user');

      expect(user, equals(Left(AuthFailure(message: 'Login failed'))));
    });

    test('should verify sign out is called', () async {
      fireBaseUserRepositoryImpl.logOutUser();

      verify(mockFireBaseAuth.signOut());
    });
  });
}
