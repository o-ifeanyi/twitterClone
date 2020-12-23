import 'package:cached_network_image/cached_network_image.dart';
import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/representation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerUserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _customLightStyle = TextStyle(
      color: Theme.of(context).accentColor,
      fontSize: Config.xMargin(context, 4),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.userProfile == null) {
            return Container(
              height: Config.yMargin(context, 16.5),
            );
          }
          final profile = state.userProfile;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: profile.profilePhoto,
                imageBuilder: (_, imageProvider) => CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).accentColor,
                  backgroundImage: imageProvider,
                ),
                placeholder: (_, __) => CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).accentColor,
                  child: Icon(Icons.person, size: Config.xMargin(context, 12)),
                ),
                fit: BoxFit.contain,
              ),
              SizedBox(height: 8),
              Text(
                profile.name,
                style: TextStyle(
                    fontSize: Config.xMargin(context, 5),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                profile.userName,
                style: _customLightStyle,
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${profile.following}',
                    style: TextStyle(
                        fontSize: Config.xMargin(context, 4),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' Followng',
                    style: _customLightStyle,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${profile.followers}',
                    style: TextStyle(
                        fontSize: Config.xMargin(context, 4),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' Followers',
                    style: _customLightStyle,
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
