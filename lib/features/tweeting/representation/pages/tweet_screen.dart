import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/bloc/profile_bloc.dart';
import 'package:fc_twitter/features/profile/representation/widgets/avatar.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/representation/bloc/bloc.dart';
import 'package:fc_twitter/features/tweeting/representation/bloc/tweet_media_bloc.dart';
import 'package:fc_twitter/features/tweeting/representation/widgets/media_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

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
    final isPotrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final profile = context.select<ProfileBloc, UserProfileEntity>(
      (bloc) => bloc.state.userProfile,
    );
    if (profile != null) {
      _tweet = TweetEntity(
        id: null,
        userId: profile.id,
        message: _tweetMessage,
        hasMedia: false,
        timeStamp: Timestamp.now(),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: isPotrait,
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
                    context
                        .read<TweetingBloc>()
                        .add(SendTweet(tweet: _tweet, userProfile: profile));
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
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: profile != null
                        ? Avatar(userProfile: profile, radius: 20)
                        : CircleAvatar(),
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
                        maxLines: 2,
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
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(left: 60),
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: BlocBuilder<TweetMediaBloc, TweetMediaState>(
                    builder: (context, state) {
                      if (state is MultiImagesLoaded) {
                        _tweet = _tweet.copyWith(
                          images: state.images,
                          hasMedia: state.images.isNotEmpty,
                        );
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.images.length,
                          itemBuilder: (context, index) => Container(
                            constraints: BoxConstraints(
                              maxWidth: 340,
                              maxHeight:
                                  state.images[index].originalHeight.toDouble(),
                            ),
                            padding: const EdgeInsets.only(right: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: AssetThumb(
                                asset: state.images[index],
                                width: state.images[index].originalWidth,
                                height: state.images[index].originalHeight,
                              ),
                            ),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ),
              ),
              Spacer(),
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
          if (_tweetMessage.isEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 60),
                height: Config.yMargin(context, 10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(15, (index) {
                    return MediaPreview(index);
                  }),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
