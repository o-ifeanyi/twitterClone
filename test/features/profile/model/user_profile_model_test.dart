import 'dart:convert';

import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';

void main() {
  MockDocumentSnapshot documentSnapshot;
  UserProfileModel userModel;
  UserProfileEntity userEntity;

  setUp(() {
documentSnapshot = MockDocumentSnapshot();
userModel = UserProfileModel(
    id: '001',
    name: 'ifeanyi',
    userName: 'onuoha',
  );

  userEntity = UserProfileEntity(
    id: '001',
    name: 'ifeanyi',
    userName: 'onuoha',
  );
  });
  
  group('userModel', () {
    test('should be a sub type of UserProfileEntity', () async {
      expect(userModel, isA<UserProfileEntity>());
    });

    test('should return a valid model wwhen converting from entity', () async {
      final result = UserProfileModel.fromEntity(userEntity);

      expect(result, equals(userModel));
    });

    test('should return a valid model wwhen converting to entity', () async {
      final result = userModel.toEntity();

      expect(result, equals(userEntity));
    });

    test('should return a valid model wwhen converting from documentSnapshot',
        () async {
      when(documentSnapshot.id).thenReturn('001');
      when(documentSnapshot.data()).thenReturn(json.decode(userFixture()));

      final result = UserProfileModel.fromDoc(documentSnapshot);

      expect(result, equals(userModel));
    });

    test(
        'should return a JSON map containing proper data when converting to document',
        () async {
      final result = userModel.toMap();

      final expected = {
        'id': '001',
        'name': 'ifeanyi',
        'userName': 'onuoha',
        'bio': null,
        'location': null,
        'website': null,
        'dateOfBirth': null,
        'dateJoined': null,
        'following': null,
        'followers': null
      };

      expect(result, equals(expected));
    });
  });
}
