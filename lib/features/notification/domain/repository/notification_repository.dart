import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';

abstract class NotificationRepository {
  Future<Either<NotificationFailure, bool>> sendLikeNotification(TweetEntity userProfileReference);

  Future<Either<NotificationFailure, bool>> markAllAsSeen(String userId);

  Future<Either<NotificationFailure, StreamConverter>> fetchNotifications(String userId);
}