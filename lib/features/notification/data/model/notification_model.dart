import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/notification/domain/entity/notification_entity.dart';
import 'package:flutter/cupertino.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    @required userProfile,
    @required tweet,
    userId,
    isSeen,
  }) : super(
          userId: userId,
          userProfile: userProfile,
          tweet: tweet,
          isSeen: isSeen ?? false,
        );

  factory NotificationModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data();
    return NotificationModel(
      userId: data['userId'],
      userProfile: data['userProfile'],
      tweet: data['tweet'],
      isSeen: data['isSeen'],
    );
  }

  factory NotificationModel.fromEntity(NotificationEntity notification) {
    return NotificationModel(
      userId: notification.userId,
      userProfile: notification.userProfile,
      tweet: notification.tweet,
      isSeen: notification.isSeen,
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      userId: this.userId,
      userProfile: this.userProfile,
      tweet: this.tweet,
      isSeen: this.isSeen,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'userProfile': this.userProfile,
      'tweet': this.tweet,
      'isSeen': this.isSeen,
    };
  }
}
