import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/authentication/data/model/user_model.dart';
import 'package:fc_twitter/features/authentication/data/repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';

void main() {
  UserModel userModel;
  UserProfileModel userProfileModel;
  MockFireBaseAuth mockFireBaseAuth;
  FirebaseFirestore mockFirebaseFirestore;
  MockUserCredential mockUserCredential;
  MockFirebaseMessaging mockFirebaseMessaging;
  UserRepositoryImpl fireBaseUserRepositoryImpl;
  MockCollectionReference collectionReference;
  MockDocumentReference documentReference;
  MockFireBaseUser mockUser;

  setUp(() {
    userModel = userModelFixture();
    userProfileModel = userProfileModelFixture();
    mockUser = MockFireBaseUser();
    mockFireBaseAuth = MockFireBaseAuth();
    mockUserCredential = MockUserCredential();
    mockFirebaseMessaging = MockFirebaseMessaging();
    mockFirebaseFirestore = MockFirebaseFirestore();
    collectionReference = MockCollectionReference();
    documentReference = MockDocumentReference();
    fireBaseUserRepositoryImpl = UserRepositoryImpl(
      firebaseAuth: mockFireBaseAuth,
      firebaseFirestore: mockFirebaseFirestore,
      firebaseMessaging: mockFirebaseMessaging,
    );
  });

  group('user repository signUpNewUser', () {
    test('should return a new user when successful', () async {
      when(mockFireBaseAuth.createUserWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer(
        (_) => Future.value(mockUserCredential),
      );
      final user = await fireBaseUserRepositoryImpl.signUpNewUser(userModel);

      expect(user, equals(Right(mockUserCredential)));
    });

    test('should return a AuthFailure when error occurs', () async {
      when(mockFireBaseAuth.createUserWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(Error());
      final user = await fireBaseUserRepositoryImpl.signUpNewUser(userModel);

      expect(user, equals(Left(AuthFailure(message: 'Sign up failed'))));
    });

    test('should verify sign out is called', () async {
      fireBaseUserRepositoryImpl.logOutUser();

      verify(mockFireBaseAuth.signOut());
    });
  });

  group('user repository logInUser', () {
    test('should return a new user when succesful', () async {
      when(mockFireBaseAuth.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer(
        (_) => Future.value(mockUserCredential),
      );
      final user = await fireBaseUserRepositoryImpl.logInUser(userModel);

      expect(user, equals(Right(mockUserCredential)));
    });

    test('should return an AuthFailure when error occurs during login',
        () async {
      when(mockFireBaseAuth.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(Error());

      final user = await fireBaseUserRepositoryImpl.logInUser(userModel);

      expect(user, equals(Left(AuthFailure(message: 'Login failed'))));
    });
  });

  group('user repository saveUserDetail', () {
    test('should return true when successful', () async {
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('user-id');
      when(mockFirebaseFirestore.collection(any))
          .thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenReturn(documentReference);
      when(documentReference.set(any)).thenAnswer((realInvocation) => null);
      when(mockFirebaseMessaging.getToken()).thenAnswer((_) => Future.value('token'));

      final user =
          await fireBaseUserRepositoryImpl.saveUserDetail(userProfileModel);

      expect(user, equals(Right(true)));
    });

    test('should return an AuthFailure when it fails', () async {
      when(mockFirebaseFirestore.collection(any)).thenThrow(Error());

      final user =
          await fireBaseUserRepositoryImpl.saveUserDetail(userProfileModel);

      expect(user, equals(Left(AuthFailure(message: 'Saving failed'))));
    });
  });
}
