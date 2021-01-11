import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/tweeting/data/model/tweet_model.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';

void main() {
  MockDocumentSnapshot documentSnapshot = MockDocumentSnapshot();
  final tweetModel = tweetModelFixture();

  final tweetEntity = tweetEntityFixture();
  group('tweetModel', () {
    test('should be a sub type of TweetEntity', () async {
      expect(tweetModel, isA<TweetEntity>());
    });

    test('should return a valid model wwhen converting from entity', () async {
      final result = TweetModel.fromEntity(tweetEntity);

      expect(result, equals(tweetModel));
    });

    test('should return a valid model wwhen converting to entity', () async {
      final result = tweetModel.toEntity();

      expect(result, equals(tweetEntity));
    });

    test('should return a valid model wwhen converting from snapshot',
        () async {
      when(documentSnapshot.id).thenReturn('001');
      final data = json.decode(jsonTweetFixture());
      data['timeStamp'] = Timestamp(0, 0);
      when(documentSnapshot.data()).thenReturn(data);

      final result = TweetModel.fromSnapShot(documentSnapshot);

      expect(result, equals(tweetModel));
    });

    test(
        'should return a JSON map containing proper data when converting to document',
        () async {
      final result = tweetModel.toMap();

      final expected = {
        'id': '001',
        'userId': '001',
        'message': 'hello world',
        'timeStamp': Timestamp(0, 0),
        'userProfile': docReference,
        'retweetersProfile': null,
        'quoteTo': null,
        'commentTo': null,
        'retweetTo': null,
        'noOfComments': 0,
        'images': null,
        'retweetedBy': null,
        'likedBy': null,
        'isQuote': null,
        'hasMedia': false,
        'isRetweet': false,
        'isComment': false
      };

      expect(result, equals(expected));
    });
  });
}
