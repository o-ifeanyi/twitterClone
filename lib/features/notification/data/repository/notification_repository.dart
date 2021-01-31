import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/features/notification/data/model/notification_model.dart';
import 'package:fc_twitter/features/notification/domain/repository/notification_repository.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/secrets.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseMessaging firebaseMessaging;
  final http.Client httpClient;

  NotificationRepositoryImpl(
      {this.firebaseFirestore, this.firebaseMessaging, this.httpClient});

  @override
  Future<Either<NotificationFailure, bool>> sendLikeNotification(
      TweetEntity tweet) async {
    try {
      final String serverToken = SERVER_TOKEN;
      final user = await tweet.userProfile
          .get()
          ?.then((value) => UserProfileModel.fromDoc(value));

      final notification = NotificationModel(
        userId: tweet.userId,
        tweet: firebaseFirestore.collection('tweets').doc(tweet.id),
        userProfile: tweet.likedBy?.last,
        isSeen: false,
      );

      await firebaseFirestore
          .collection('notifications')
          .add(notification.toMap());

      final response = await httpClient.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'this is a body',
              'title': 'this is a title'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': user?.token,
          },
        ),
      );

      if (response.statusCode == 200) {
        return Right(true);
      } else {
        throw Error();
      }
    } catch (error) {
      print(error);
      return Left(NotificationFailure(message: 'Failed to notify'));
    }
  }

  @override
  Future<Either<NotificationFailure, StreamConverter>> fetchNotifications(
      String userId) async {
    print(userId);
    if (userId == null) {
      print('userid is null');
    }
    try {
      final collection = firebaseFirestore
          .collection('notifications')
          .where('userId', isEqualTo: userId);
      return Right(StreamConverter(query: collection));
    } catch (error) {
      print(error);
      return Left(NotificationFailure(message: 'Failed to notify'));
    }
  }

  @override
  Future<Either<NotificationFailure, bool>> markAllAsSeen(String userId) async {
    try {
      final snapshot = await firebaseFirestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isSeen', isEqualTo: false)
          .get();
      for (var notification in snapshot.docs) {
        await notification.reference.update({'isSeen': true});
      }
      return Right(true);
    } catch (error) {
      print(error);
      return Left(NotificationFailure(message: 'Failed to mark as seen'));
    }
  }
}
