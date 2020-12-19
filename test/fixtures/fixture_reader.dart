import 'dart:convert';
import 'dart:io';

import 'package:fc_twitter/features/authentication/data/model/user_model.dart';
import 'package:fc_twitter/features/authentication/domain/user_entity/user_entity.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/settings/data/model/theme_model.dart';
import 'package:fc_twitter/features/settings/domain/entity/theme_entity.dart';
import 'package:fc_twitter/features/tweeting/data/model/tweet_model.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';

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
      profilePhoto: File('test'),
    );

String jsonUserProfileFixture() => json.encode({
      "id": "001",
      "name": "ifeanyi",
      "userName": "onuoha",
      "location": "Abuja",
    });

TweetEntity tweetEntityFixture() => TweetEntity(
      name: 'ifeanyi',
      userName: 'onuoha',
      message: 'hello world',
      timeStamp: '0s',
    );

TweetModel tweetModelFixture() => TweetModel(
      name: 'ifeanyi',
      userName: 'onuoha',
      message: 'hello world',
      timeStamp: '0s',
    );

String jsonTweetFixture() => json.encode({
      "name": "ifeanyi",
      "userName": "onuoha",
      "message": "hello world",
      "timeStamp": "0s"
    });
