import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/features/notification/data/repository/notification_repository.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart' as mock;

void main() {
  mock.MockFirebaseFirestore mockFirebaseFirestore;
  mock.MockFirebaseMessaging mockFirebaseMessaging;
  mock.MockClient mockClient;
  mock.MockCollectionReference collectionReference;
  mock.MockQuery query;
  TweetEntity tweetEntity;
  NotificationRepositoryImpl notificationRepositoryImpl;

  setUp(() {
    tweetEntity = tweetEntityFixture();
    mockFirebaseFirestore = mock.MockFirebaseFirestore();
    mockFirebaseMessaging = mock.MockFirebaseMessaging();
    mockClient = mock.MockClient();
    collectionReference = mock.MockCollectionReference();
    query = mock.MockQuery();
    notificationRepositoryImpl = NotificationRepositoryImpl(
      firebaseFirestore: mockFirebaseFirestore,
      firebaseMessaging: mockFirebaseMessaging,
      httpClient: mockClient,
    );
  });

  group('notification repository fetchNotifications', () {
    test('should return a StreamConverter when successful', () async{
      when(mockFirebaseFirestore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.where(any, isEqualTo: anyNamed('isEqualTo'))).thenReturn(query);

      final result = await notificationRepositoryImpl.fetchNotifications('userId');

      expect(result, Right(StreamConverter()));
    });

    test('should return a NotificationFailure when un-successful', () async{
      when(mockFirebaseFirestore.collection(any)).thenThrow(Error());

      final result = await notificationRepositoryImpl.fetchNotifications('userId');

      expect(result, Left(NotificationFailure(message: 'Failed to notify')));
    });
  });

  group('notification repository SendLikeNotifcation', () {
    test('should return true when successful', () async{
      when(mockFirebaseFirestore.collection(any)).thenReturn(collectionReference);
      when(
        mockClient.post(any,
            headers: anyNamed('headers'), body: anyNamed('body')),
      ).thenAnswer((_) => Future.value(Response('', 200)));

      final response = await notificationRepositoryImpl.sendLikeNotification(tweetEntity);

      expect(response, Right(true));
    });

    test('should return NotificationFailure when un-successful', () async{
      when(
        mockClient.post(any,
            headers: anyNamed('headers'), body: anyNamed('body')),
      ).thenAnswer((_) => Future.value(Response('', 500)));

      final response = await notificationRepositoryImpl.sendLikeNotification(tweetEntity);

      expect(response, Left(NotificationFailure(message: 'Failed to notify')));
    });
  });

  group('notification repository MarkAllAsRead', () {
    test('should return true when successful', () async{
      when(mockFirebaseFirestore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.where(any, isEqualTo: anyNamed('isEqualTo'))).thenReturn(query);
      when(query.where(any, isEqualTo: anyNamed('isEqualTo'))).thenReturn(query);

      final response = await notificationRepositoryImpl.markAllAsSeen('userId');

      expect(response, Right(true));
    });

    test('should return NotificationFailure when un-successful', () async{
      when(mockFirebaseFirestore.collection(any)).thenThrow(Error());

      final response = await notificationRepositoryImpl.markAllAsSeen('userId');

      expect(response, Left(NotificationFailure(message: 'Failed to mark as seen')));
    });
  });
}
