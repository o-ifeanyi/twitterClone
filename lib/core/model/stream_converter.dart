import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/tweeting/data/model/tweet_model.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';

class StreamConverter extends Equatable {
  final CollectionReference collection;
  final Query query;

  StreamConverter({this.collection, this.query});

  Stream<List<TweetEntity>> fromCollection(CollectionReference tweets) {
    return tweets.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TweetModel.fromSnapShot(doc))
          .toList();
    });
  }

  Stream<List<TweetEntity>> fromQuery(Query query, {String id}) {
    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TweetModel.fromSnapShot(doc))
          .toList();
    });
  }

  @override
  List<Object> get props => [];
}
