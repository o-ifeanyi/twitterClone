import 'dart:convert';

import 'package:fc_twitter/features/notification/data/model/notification_model.dart';
import 'package:fc_twitter/features/notification/domain/entity/notification_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';

void main() {
  MockDocumentSnapshot documentSnapshot;
  NotificationModel notificationModel;
  NotificationEntity notificationEntity;

  setUp(() {
    documentSnapshot = MockDocumentSnapshot();
    notificationModel = notificationModelFixture();
    notificationEntity = notificationEntityFixture();
  });

  group('NotificationModel', () {
    test('should be a sub type of NotificationEntity', () {
      expect(notificationModel, isA<NotificationEntity>());
    });

    test('should return a valid model wwhen converting from entity', () {
      final result = NotificationModel.fromEntity(notificationEntity);

      expect(result, equals(notificationModel));
    });

    test('should return a valid model wwhen converting to entity', () {
      final result = notificationModel.toEntity();

      expect(result, equals(notificationEntity));
    });

    test('should return a valid model wwhen converting from documentSnapshot', () {
      when(documentSnapshot.data())
          .thenReturn(json.decode(jsonNotificationFixture()));
      final result = NotificationModel.fromDoc(documentSnapshot);

      expect(result, equals(notificationModel));
    });

    test('should return a JSON map containing proper data when converting to document', () {
      final result = notificationModel.toMap();

      final expected = {
        'userId': '001',
        'userProfile': docReference,
        'tweet': docReference,
        'isSeen': false,
      };

      expect(result, equals(expected));
    });
  });
}
