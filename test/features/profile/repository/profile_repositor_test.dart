import 'dart:convert';
import 'dart:io';

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

      expect(result, Left(ProfileFailure()));
    });
  });

  group('profile repository updateUserProfile', () {
    test('should verify upload functionality when neew image is selected',
        () async {
      when(firebaseFirestore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenReturn(documentReference);
      when(documentReference.set(any)).thenAnswer((realInvocation) => null);

      final result = await profileRepositoryImpl.updateUserProfile(userEntity);

      expect(result, Right(true));
    });

    test('should return ProfileFailure when it fails', () async {
      when(firebaseFirestore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenReturn(documentReference);
      when(documentReference.set(any)).thenThrow(Error());

      final result = await profileRepositoryImpl.updateUserProfile(userEntity);

      expect(result, Left(ProfileFailure()));
    });
  });

  group('profile repository uploadImage', () {
    test('should verify upload functionality when new image is selected',
        () async {
      // when userEntity photo property holds a File object (new image was selected)
      final profileWithNewImage =
          userEntity.copyWith(profilePhoto: File('imagePath'), coverPhoto: File('imagePath'));
      when(firebaseStorage.ref(any)).thenReturn(reference);
      when(reference.child(any)).thenReturn(reference);

      await profileRepositoryImpl.uploadImage(profileWithNewImage);

      verify(firebaseStorage.ref(any));
      verify(reference.child(any));
      verify(reference.putFile(any));
    });

    test('should verify no upload functionality when no new image is selected',
        () async {
      // when userEntity photo property holds a File object (new image was selected)
      final profileWithOutNewImage =
          userEntity.copyWith(profilePhoto: 'urlPath', coverPhoto: 'urlPath');
      when(firebaseStorage.ref(any)).thenReturn(reference);
      when(reference.child(any)).thenReturn(reference);

      await profileRepositoryImpl.uploadImage(profileWithOutNewImage);

      verifyNever(firebaseStorage.ref(any));
      verifyNever(reference.child(any));
      verifyNever(reference.putFile(any));
    });
  });

  group('profile repository follow', () {
    test('should return true when successful', () async {
      when(firebaseFirestore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenReturn(documentReference);
      when(documentReference.update(any))
          .thenAnswer((_) => null);

      final result = await profileRepositoryImpl.follow(userEntity, userEntity);

      expect(result, Right(true));
    });

    test('should return ProfileFailure when it fails', () async {
      when(firebaseFirestore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenThrow(Error());

      final result = await profileRepositoryImpl.follow(userEntity, userEntity);

      expect(result, Left(ProfileFailure()));
    });
  });

  group('profile repository unFollow', () {
    test('should return true when successful', () async {
      when(firebaseFirestore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenReturn(documentReference);
      when(documentReference.update(any))
          .thenAnswer((_) => null);

      final result = await profileRepositoryImpl.unfollow(userEntity, userEntity);

      expect(result, Right(true));
    });

    test('should return ProfileFailure when it fails', () async {
      when(firebaseFirestore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenThrow(Error());

      final result = await profileRepositoryImpl.unfollow(userEntity, userEntity);

      expect(result, Left(ProfileFailure()));
    });
  });
}
