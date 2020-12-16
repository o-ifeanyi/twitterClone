import 'dart:convert';

String tweetFixture() => json.encode({
      "name": "ifeanyi",
      "userName": "onuoha",
      "message": "hello world",
      "timeStamp": "0s"
    });

String userFixture() => json.encode({
      "id": "001",
      "name": "ifeanyi",
      "userName": "onuoha",
    });

String themeFixture() => json.encode({
      "isLight": true,
      "isDi": false,
      "isLightsOut": true,
    });
