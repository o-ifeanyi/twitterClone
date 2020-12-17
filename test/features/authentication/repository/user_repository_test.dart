import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/authentication/data/model/user_model.dart';
import 'package:fc_twitter/features/authentication/data/repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.dart';

void main() {
  UserModel userModel;
  UserProfileModel userProfileModel;
  MockFireBaseAuth mockFireBaseAuth;
  FirebaseFirestore mockFirebaseFirestore;
  MockUserCredential mockUserCredential;
  UserRepositoryImpl fireBaseUserRepositoryImpl;
  MockCollectionReference collectionReference;
  MockDocumentReference documentReference;
  MockFireBaseUser mockUser;

  setUp(() {
    userModel = UserModel(email: 'ifeanyi@email.com', password: '123456');
    userProfileModel = UserProfileModel(id: '001', name: 'ifeanyi', userName: 'onuoha');
    mockUser = MockFireBaseUser();
    mockFireBaseAuth = MockFireBaseAuth();
    mockUserCredential = MockUserCredential();
    mockFirebaseFirestore = MockFirebaseFirestore();
    collectionReference = MockCollectionReference();
    documentReference = MockDocumentReference();
    fireBaseUserRepositoryImpl = UserRepositoryImpl(
        firebaseAuth: mockFireBaseAuth,
        firebaseFirestore: mockFirebaseFirestore);
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

    test('should return true when saving user detail occurs successfully',
        () async {
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('user-id');
      when(mockFirebaseFirestore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenReturn(documentReference);
      when(documentReference.set(any)).thenAnswer((realInvocation) => null);

      final user = await fireBaseUserRepositoryImpl.saveUserDetail(userProfileModel);

      expect(user, equals(Right(true)));
    });

    test('should return an AuthFailure when saving user detail fails',
        () async {
      when(mockFirebaseFirestore.collection(any)).thenThrow(Error());

      final user = await fireBaseUserRepositoryImpl.saveUserDetail(userProfileModel);

      expect(user, equals(Left(AuthFailure(message: 'Saving failed'))));
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

      expect(user, equals(Left(AuthFailure(message: 'Login failed'))));
    });

    test('should verify sign out is called', () async {
      fireBaseUserRepositoryImpl.logOutUser();

      verify(mockFireBaseAuth.signOut());
    });
  });
}
