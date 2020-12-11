import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/features/timeline/data/model/tweet_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CollectionReference collection;
  FirebaseFirestore firebaseFirestore;
  StreamConverter streamConverter;

  setUp(() {
    firebaseFirestore = MockFirestoreInstance();
  });

  group('stream converter', () {
    test('Should hold an initial stream of type CollectionReference', () async {
      collection = firebaseFirestore.collection('tweets');

      streamConverter = StreamConverter(collection: collection);

      expect(streamConverter.collection, isA<CollectionReference>());
    });

    test('Should return a stream of type TweetModel when toTweetModel is called', () async {
      collection = firebaseFirestore.collection('tweets');

      streamConverter = StreamConverter(collection: collection);

      expect(streamConverter.collection, isA<CollectionReference>());

      final converted = streamConverter.toTweetModel(collection);

      expect(converted, isA<Stream<List<TweetModel>>>());
    });
  });
}
