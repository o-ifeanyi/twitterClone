import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mocks.dart';

void main() {
  CollectionReference collection;
  FirebaseFirestore firebaseFirestore;
  StreamConverter streamConverter;
  // ignore: close_sinks
  StreamController streamController;

  setUp(() {
    firebaseFirestore = MockFirebaseFirestore();
    collection = MockCollectionReference();
    streamController = StreamController<QuerySnapshot>();
  });

  group('stream converter', () {
    test('Should hold an initial stream of type CollectionReference', () async {
      when(firebaseFirestore.collection(any)).thenReturn(collection);
      collection = firebaseFirestore.collection('tweets');

      streamConverter = StreamConverter(collection: collection);

      expect(streamConverter.collection, isA<CollectionReference>());
    });

    test('Should return a stream of type TweetEntity when toTweetModel is called', () async {
      when(firebaseFirestore.collection(any)).thenReturn(collection);
      when(collection.snapshots()).thenAnswer((_) => streamController.stream);

      collection = firebaseFirestore.collection('tweets');

      streamConverter = StreamConverter(collection: collection);

      expect(streamConverter.collection, isA<CollectionReference>());

      final converted = streamConverter.toTweetEntity(collection);

      expect(converted, isA<Stream<List<TweetEntity>>>());
    });
  });
}
