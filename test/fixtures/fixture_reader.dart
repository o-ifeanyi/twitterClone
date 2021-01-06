import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/authentication/data/model/user_model.dart';
import 'package:fc_twitter/features/authentication/domain/user_entity/user_entity.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/settings/data/model/theme_model.dart';
import 'package:fc_twitter/features/settings/domain/entity/theme_entity.dart';
import 'package:fc_twitter/features/tweeting/data/model/tweet_model.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';

import '../mocks/mocks.dart';

final _mockDocumentReference = MockDocumentReference();

MockDocumentReference get docReference => _mockDocumentReference;

Map<String, dynamic> themeJsonFixture() => {
      'isLight': true,
      'isDim': false,
      'isLightsOut': true,
    };

ThemeModel themeModelFixture() => ThemeModel(
      isLight: true,
      isDim: false,
      isLightsOut: true,
    );

ThemeEntity themeEntityFixture() => ThemeEntity(
      isLight: true,
      isDim: false,
      isLightsOut: true,
    );

UserEntity userEntityFixture() => UserEntity(
      email: 'ifeanyi@email.com',
      password: '123456',
      userName: 'onuoha',
    );

UserModel userModelFixture() => UserModel(
      email: 'ifeanyi@email.com',
      password: '123456',
      userName: 'onuoha',
    );

UserProfileModel userProfileModelFixture() => UserProfileModel(
      id: '001',
      name: 'ifeanyi',
      userName: 'onuoha',
      location: 'Abuja',
    );

UserProfileEntity userProfileEntityFixture() => UserProfileEntity(
      id: '001',
      name: 'ifeanyi',
      userName: 'onuoha',
      location: 'Abuja',
    );

String jsonUserProfileFixture() => json.encode({
      "id": "001",
      "name": "ifeanyi",
      "userName": "onuoha",
      "location": "Abuja",
      "bio": null,
      "website": null,
      "dateOfBirth": null,
      "dateJoined": null,
      "profilePhoto": null,
      "coverPhoto": null,
      "following": null,
      "followers": null
    });

TweetEntity tweetEntityFixture() => TweetEntity(
      id: '001',
      userProfile: docReference,
      message: 'hello world',
      noOfComments: 0,
      isComment: false,
      isRetweet: false,
      hasMedia: false,
      timeStamp: Timestamp(0, 0),
    );

TweetModel tweetModelFixture() => TweetModel(
      id: '001',
      userProfile: docReference,
      message: 'hello world',
      noOfComments: 0,
      isComment: false,
      isRetweet: false,
      hasMedia: false,
      timeStamp: Timestamp(0, 0),
    );

String jsonTweetFixture() => json.encode({
      // "userProfile": json.decode(jsonUserProfileFixture()),
      "message": "hello world",
      "timeStamp": "0s",
      "noOfComments": 0,
    });