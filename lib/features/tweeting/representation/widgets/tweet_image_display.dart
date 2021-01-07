import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fc_twitter/core/util/config.dart';

class TweetImageDisplay extends StatelessWidget {
  const TweetImageDisplay({
    Key key,
    @required this.tweet,
  }) : super(key: key);

  final TweetEntity tweet;

  Widget _buildImage(BuildContext context, String url) {
    final theme = Theme.of(context);
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (_, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (_, __) => Container(
        decoration: BoxDecoration(
          color: theme.accentColor,
        ),
      ),
      fit: BoxFit.cover,
    );
  }

  Widget _getLayout(BuildContext context, TweetEntity tweet) {
    switch (tweet.images.length) {
      case 1:
        return Expanded(
          child: _buildImage(context, tweet.images[0]),
        );
        break;
      case 2:
        return Row(
          children: [
            Expanded(
              child: _buildImage(context, tweet.images[0]),
            ),
            SizedBox(width: 5),
            Expanded(
              child: _buildImage(context, tweet.images[1]),
            )
          ],
        );
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        height: Config.yMargin(context, 25),
        child: _getLayout(context, tweet),
      ),
    );
  }
}
