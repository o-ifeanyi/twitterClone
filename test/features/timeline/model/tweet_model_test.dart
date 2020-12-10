import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/timeline/data/model/tweet_model.dart';
import 'package:fc_twitter/features/timeline/domain/entity/tweet_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tweetModel = TweetModel(
    name: 'ifeanyi',
    userName: 'onuoha',
    message: 'hello world',
    timeStamp: '0s',
  );
  group('tweetModel', () {
    test('should be a sub type of TweetEntity', () async {
      expect(tweetModel, isA<TweetEntity>());
    });

    test('should return a valid model wwhen converting from snapshot',
        () async {
      final snapshot = (json.decode(fixture('tweet.json')));

      snapshot['timeStamp'] = Timestamp.now();

      final result = TweetModel.fromSnapShot(snapshot);

      expect(result, equals(tweetModel));
    });

    test('should return a JSON map containing proper data when converting to document', () async {
      final result = tweetModel.toDocument();

      final expected = {
        'name': 'ifeanyi',
        'userName': 'onuoha',
        'message': 'hello world',
        'timeStamp': '0s',
      };

      expect(result, equals(expected));
    });
  });
}
