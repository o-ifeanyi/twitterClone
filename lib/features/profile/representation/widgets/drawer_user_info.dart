import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/representation/bloc/profile_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'avatar.dart';

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
        buildWhen: (_, currentState) {
          return currentState.userProfile.id == FirebaseAuth.instance.currentUser.uid;
        },
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
              Avatar(userProfile: profile, radius: 30),
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
                    '${profile.following.length}',
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
                    '${profile.followers.length}',
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
