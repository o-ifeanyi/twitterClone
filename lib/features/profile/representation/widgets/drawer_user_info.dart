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
          if (state is FetchingComplete) {
            final user = state.userProfile;
            print(user.name);
            print(user.userName);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                SizedBox(height: 8),
                Text(
                  user.name,
                  style: TextStyle(
                      fontSize: Config.xMargin(context, 5),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  user.userName,
                  style: _customLightStyle,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${user.following}',
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
                      '${user.followers}',
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
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
