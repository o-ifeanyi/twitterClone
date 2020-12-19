import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/profile/data/repository/profile_repository.dart.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';

void main() {
  FirebaseFirestore firebaseFirestore;
  FirebaseStorage firebaseStorage;
  Reference reference;
  ProfileRepositoryImpl profileRepositoryImpl;
  CollectionReference collectionReference;
  DocumentReference documentReference;
  DocumentSnapshot documentSnapshot;
  UserProfileEntity userEntity;

  setUp(() {
    userEntity = userProfileEntityFixture();
    firebaseFirestore = MockFirebaseFirestore();
    firebaseStorage = MockFirebaseStorage();
    reference = MockReference();
    collectionReference = MockCollectionReference();
    documentReference = MockDocumentReference();
    documentSnapshot = MockDocumentSnapshot();
    profileRepositoryImpl = ProfileRepositoryImpl(
      firebaseFirestore: firebaseFirestore,
      firebaseStorage: firebaseStorage,
    );
  });

  group('profile repository getUserProfile', () {
    test('should return UserProfileEntity when successful', () async {
      when(firebaseFirestore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenReturn(documentReference);
      when(documentReference.get())
          .thenAnswer((_) => Future.value(documentSnapshot));
      when(documentSnapshot.id).thenReturn('001');
      when(documentSnapshot.data())
          .thenReturn(json.decode(jsonUserProfileFixture()));

      final result = await profileRepositoryImpl.getUserProfile('test');

      expect(result, Right(userEntity));
    });

    test('should return ProfileFailure when it fails', () async {
      when(firebaseFirestore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenReturn(documentReference);
      when(documentReference.get()).thenThrow(Error());

      final result = await profileRepositoryImpl.getUserProfile('test');

      expect(result, Left(ProfileFilure()));
    });
  });

  group('profile repository updateUserProfile', () {
    test('should verify upload functionality when neew image is selected', () async {
      when(firebaseStorage.ref(any)).thenReturn(reference);
      when(reference.child(any)).thenReturn(reference);

      // userEntity photo property holds a File object (new image was selected)
      await profileRepositoryImpl.updateUserProfile(userEntity);

      verify(firebaseStorage.ref(any));
      verify(reference.child(any));
      verify(reference.putFile(any));
    });

    test('should return ProfileFailure when it fails', () async {
      when(firebaseFirestore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenReturn(documentReference);
      when(documentReference.set(any)).thenThrow(Error());

      final result = await profileRepositoryImpl.updateUserProfile(userEntity);

      expect(result, Left(ProfileFilure()));
    });
  });
}
