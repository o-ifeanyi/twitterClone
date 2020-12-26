import 'package:cached_network_image/cached_network_image.dart';
import 'package:fc_twitter/core/util/config.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key key,
    @required String imageUrl,
    @required double radius,
  })  : _imageUrl = imageUrl,
        _radius = radius,
        super(key: key);

  final String _imageUrl;
  final double _radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CachedNetworkImage(
      imageUrl: _imageUrl,
      imageBuilder: (_, imageProvider) => CircleAvatar(
        radius: _radius,
        backgroundColor: theme.accentColor,
        backgroundImage: imageProvider,
      ),
      placeholder: (_, __) => CircleAvatar(
        radius: _radius,
        backgroundColor: theme.accentColor,
        child: Icon(Icons.person, size: Config.xMargin(context, 10)),
      ),
      fit: BoxFit.contain,
    );
  }
}
