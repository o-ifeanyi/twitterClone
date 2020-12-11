import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/timeline/data/model/tweet_model.dart';

class StreamConverter extends Equatable {
  final CollectionReference collection;

  StreamConverter({this.collection});

  Stream<List<TweetModel>> toTweetModel(CollectionReference tweets) {
    return tweets.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TweetModel.fromSnapShot(doc))
          .toList();
    });
  }

  @override
  List<Object> get props => [collection];
}
