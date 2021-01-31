import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/notification/data/model/notification_model.dart';
import 'package:fc_twitter/features/notification/domain/entity/notification_entity.dart';
import 'package:fc_twitter/features/tweeting/data/model/tweet_model.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';

class StreamConverter extends Equatable {
  final CollectionReference collection;
  final Query query;

  StreamConverter({this.collection, this.query});

  Stream<List<TweetEntity>> fromCollectionToTweets(CollectionReference tweets) {
    return tweets.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TweetModel.fromSnapShot(doc))
          .toList();
    });
  }

  Stream<List<TweetEntity>> fromQueryToTweets(Query query) {
    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TweetModel.fromSnapShot(doc))
          .toList();
    });
  }

  Stream<List<NotificationEntity>> fromQueryToNotification(Query query) {
    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => NotificationModel.fromDoc(doc))
          .toList();
    });
  }

  @override
  List<Object> get props => [];
}
