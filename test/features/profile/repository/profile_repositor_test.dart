import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/features/profile/data/repository/profile_repository.dart.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';

void main() {
  FirebaseFirestore firebaseFirestore;
  ProfileRepositoryImpl profileRepositoryImpl;
  CollectionReference collectionReference;
  DocumentReference documentReference;
  DocumentSnapshot documentSnapshot;
  UserProfileEntity userEntity;

  setUp(() {
    userEntity = UserProfileEntity(
      id: '001',
      name: 'ifeanyi',
      userName: 'onuoha',
    );
    firebaseFirestore = MockFirebaseFirestore();
    collectionReference = MockCollectionReference();
    documentReference = MockDocumentReference();
    documentSnapshot = MockDocumentSnapshot();
    profileRepositoryImpl = ProfileRepositoryImpl(
      firebaseFirestore: firebaseFirestore,
    );
  });

  group('profile repository', () {
    test('should return UserProfileEntity when getUserProfile is successful',
        () async {
      when(firebaseFirestore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenReturn(documentReference);
      when(documentReference.get())
          .thenAnswer((_) => Future.value(documentSnapshot));
      when(documentSnapshot.id).thenReturn('001');
      when(documentSnapshot.data()).thenReturn(json.decode(userFixture()));

      final result = await profileRepositoryImpl.getUserProfile('test');

      expect(result, Right(userEntity));
    });
  });
}
