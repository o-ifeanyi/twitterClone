import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/tweeting/data/model/tweet_model.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
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
      final snapshot = (json.decode(jsonTweetFixture()));

      snapshot['timeStamp'] = Timestamp.now();

      final result = TweetModel.fromSnapShot(snapshot);

      expect(result, equals(tweetModel));
    });

    test(
        'should return a JSON map containing proper data when converting to document',
        () async {
      final result = tweetModel.toDocument();

      final expected = {
        'userProfile': json.decode(jsonUserProfileFixture()),
        'message': 'hello world',
        'timeStamp': '0s',
        'quoteTo': null,
        'comments': null,
        'retweetedBy': null,
        'likedBy': null,
        'isRetweet': null
      };

      expect(result, equals(expected));
    });
  });
}
