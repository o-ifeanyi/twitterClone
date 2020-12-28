import 'package:cached_network_image/cached_network_image.dart';
import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/pages/profile_screen.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key key,
    @required UserProfileEntity userProfile,
    @required double radius,
  })  : userProfile = userProfile,
        _radius = radius,
        super(key: key);

  final UserProfileEntity userProfile;
  final double _radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, ProfileScreen.pageId, arguments: userProfile),
      child: CachedNetworkImage(
        imageUrl: userProfile.profilePhoto,
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
      ),
    );
  }
}
