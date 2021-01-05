import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/bloc/profile_bloc.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/representation/bloc/bloc.dart';
import 'package:fc_twitter/features/tweeting/representation/widgets/media_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class TweetScreen extends StatefulWidget {
  static const String pageId = '/composeTweet';
  @override
  _TweetScreenState createState() => _TweetScreenState();
}

class _TweetScreenState extends State<TweetScreen> {
  final _tweetController = TextEditingController();
  final _focusNode = FocusNode();
  String _tweetMessage = '';
  TweetEntity _tweet;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.select<ProfileBloc, UserProfileEntity>(
      (bloc) => bloc.state.userProfile,
    );
    if (profile != null) {
      _tweet = TweetEntity(
        id: null,
        message: _tweetMessage,
        timeStamp: Timestamp.now(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          GestureDetector(
            onTap: _tweetMessage.isEmpty
                ? null
                : () {
                    context.read<TweetingBloc>().add(SendTweet(tweet: _tweet, userProfile: profile));
                    _focusNode.unfocus();
                    Navigator.pop(context);
                  },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              width: Config.xMargin(context, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: _tweetMessage.isEmpty
                    ? Theme.of(context).primaryColor.withOpacity(0.5)
                    : Theme.of(context).primaryColor,
              ),
              child: Text(
                'Tweet',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: Config.xMargin(context, 4)),
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: CircleAvatar(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: TextField(
                    controller: _tweetController,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: 'What\'s happening?',
                      border: InputBorder.none,
                    ),
                    onChanged: (val) {
                      setState(() {
                        _tweetMessage = val;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          // twwet.isEmpty and device 1s potrait
          if (_tweetMessage.isEmpty)
            Container(
              height: Config.yMargin(context, 10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(15, (index) {
                  return MediaPreview(index);
                }),
              ),
            ),
          SizedBox(height: 10),
          Divider(thickness: 2, height: 0),
          FlatButton.icon(
            onPressed: () {},
            icon: Icon(
              MaterialCommunityIcons.earth,
              color: Theme.of(context).primaryColor,
            ),
            label: Text(
              'Everyone can reply',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: Config.xMargin(context, 3.5),
                  fontWeight: FontWeight.w400),
            ),
          ),
          Divider(thickness: 2, height: 0),
        ],
      ),
    );
  }
}
