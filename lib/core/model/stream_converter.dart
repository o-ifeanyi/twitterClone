import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/tweeting/data/model/tweet_model.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';

class StreamConverter extends Equatable {
  final CollectionReference collection;

  StreamConverter({this.collection});

  Stream<List<TweetEntity>> toTweetEntity(CollectionReference tweets) {
    return tweets.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TweetModel.fromSnapShot(doc).toEntity())
          .toList();
    });
  }

  @override
  List<Object> get props => [collection];
}
