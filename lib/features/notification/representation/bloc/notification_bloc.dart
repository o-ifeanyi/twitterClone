import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/notification/domain/entity/notification_entity.dart';
import 'package:fc_twitter/features/notification/domain/repository/notification_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchNotifications extends NotificationEvent {
  final String userId;

  FetchNotifications({this.userId});
}

class MarkAllAsSeen extends NotificationEvent {
  final String userId;

  MarkAllAsSeen({this.userId});
}

class NotificationState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialNotificationState extends NotificationState {}

class FetchingNotifications extends NotificationState {}

class FetchingNotificationsError extends NotificationState {
  final String message;

  FetchingNotificationsError({this.message});

  @override
  List<Object> get props => [message];
}

class FetchingNotificationsComplete extends NotificationState {
  final Stream<List<NotificationEntity>> notificationStream;
  final int notificationCount;

  FetchingNotificationsComplete(
      {this.notificationStream, this.notificationCount});
  
  @override
  List<Object> get props => [notificationStream, notificationCount];
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;
  NotificationBloc(
      {NotificationState initialState, this.notificationRepository})
      : super(initialState);

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is FetchNotifications) {
      yield* _mapFetchNotificationsToState(event.userId);
    }
    if (event is MarkAllAsSeen) {
      await notificationRepository.markAllAsSeen(event.userId);
      yield* _mapFetchNotificationsToState(event.userId);
    }
  }

  Stream<NotificationState> _mapFetchNotificationsToState(
      String userId) async* {
    yield FetchingNotifications();
    final fetchEither = await notificationRepository.fetchNotifications(userId);
    yield* fetchEither.fold(
      (failure) async* {
        yield FetchingNotificationsError(message: failure.message);
      },
      (converter) async* {
        // converter.fromQueryToNotification(converter.query).listen((event) {
        //   print(event);
        // });
        final notificationStream =
            converter.fromQueryToNotification(converter.query);
        // timeout is needed for the test
        final count = await notificationStream
            .timeout(Duration(seconds: 15), onTimeout: (sink) => sink.add([]))
            .first
            .then((value) => value.where((element) => !element.isSeen).length);
        print('notification count $count');
        yield FetchingNotificationsComplete(
          notificationCount: count,
          notificationStream: notificationStream,
        );
      },
    );
  }
}
