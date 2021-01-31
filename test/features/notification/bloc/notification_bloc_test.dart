import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/features/notification/representation/bloc/notification_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.dart';

void main() {
  MockCollectionReference collectionReference;
  // ignore: close_sinks
  StreamController streamController;
  NotificationBloc notificationBloc;
  MockNotificationRepository mockNotificationRepository;

  setUp(() {
    collectionReference = MockCollectionReference();
    mockNotificationRepository = MockNotificationRepository();
    streamController = StreamController<QuerySnapshot>();
    notificationBloc = NotificationBloc(
      initialState: InitialNotificationState(),
      notificationRepository: mockNotificationRepository,
    );
  });

  test(('confirm initial bloc state'), () {
    expect(notificationBloc.state, equals(InitialNotificationState()));
  });

  group('notification bloc FetchNotifications event', () {
    test(
        'should emit [FetchingNotifications, FetchingNotificationsComplete] when successful',
        () async {
      when(collectionReference.snapshots())
          .thenAnswer((_) => streamController.stream);
      when(mockNotificationRepository.fetchNotifications(any)).thenAnswer(
        (_) => Future.value(Right(StreamConverter(query: collectionReference))),
      );

      final expectations = [
        FetchingNotifications(),
        FetchingNotificationsComplete(),
      ];
      expectLater(notificationBloc, emitsInOrder(expectations));

      notificationBloc.add(FetchNotifications(userId: '001'));
    });

    test(
        'should emit [FetchingNotifications, FetchingNotificationsFailed] when it fails',
        () async {
      when(mockNotificationRepository.fetchNotifications(any)).thenAnswer(
        (_) => Future.value(
            Left(NotificationFailure(message: 'Failed to notify'))),
      );
      final expectations = [
        FetchingNotifications(),
        FetchingNotificationsError(message: 'Failed to notify'),
      ];
      expectLater(notificationBloc, emitsInOrder(expectations));

      notificationBloc.add(FetchNotifications(userId: '001'));
    });
  });

  group('notification bloc MarkAllAsSeen event', () {
    test(
        'should emit [FetchingNotifications, FetchingNotificationsComplete] when successful',
        () async {
      when(mockNotificationRepository.markAllAsSeen(any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );
      when(mockNotificationRepository.fetchNotifications(any)).thenAnswer(
        (_) => Future.value(Right(StreamConverter(query: collectionReference))),
      );
      when(collectionReference.snapshots())
          .thenAnswer((_) => streamController.stream);

      final expectations = [
        FetchingNotifications(),
        FetchingNotificationsComplete(),
      ];
      expectLater(notificationBloc, emitsInOrder(expectations));

      notificationBloc.add(MarkAllAsSeen(userId: '001'));
    });
  });
}
