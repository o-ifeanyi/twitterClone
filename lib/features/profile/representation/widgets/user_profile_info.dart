import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/representation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class UserProfileInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final _customGreyText = TextStyle(
      color: theme.accentColor,
      fontSize: Config.xMargin(context, 4),
    );
    final _customWhiteText = TextStyle(
      fontSize: Config.xMargin(context, 3.5),
    );
    return LayoutBuilder(builder: (context, constraints) {
      return BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is FetchingComplete) {
            final profile = state.userProfile;
            print(profile.id);
            return Stack(
              children: [
                Container(
                  height: constraints.maxHeight * 0.35,
                  decoration: BoxDecoration(color: theme.primaryColor),
                ),
                Positioned(
                  top: Config.yMargin(context, 13),
                  child: Container(
                    height: constraints.maxHeight * 0.65,
                    // color: Colors.green,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: theme.accentColor,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: theme.accentColor,
                                ),
                              ),
                              child: Text(
                                'Edit profile',
                                style: _customGreyText,
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(height: 8),
                        Text(
                          profile.name,
                          style: TextStyle(
                              fontSize: Config.xMargin(context, 5),
                              fontWeight: FontWeight.bold),
                        ),
                        // SizedBox(height: 5),
                        Text(
                          profile.userName,
                          style: _customGreyText,
                        ),
                        // SizedBox(height: 8),
                        if (profile.bio.isNotEmpty)
                          Text(profile.bio, style: _customWhiteText),
                        // SizedBox(height: 8),
                        if (profile.location.isNotEmpty &&
                            profile.website.isNotEmpty)
                          Row(
                            children: [
                              if (profile.location.isNotEmpty) ...[
                                Icon(
                                  EvilIcons.location,
                                  size: 18,
                                  color: theme.accentColor,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Abuja | Kaduna, Nigeria',
                                  style: _customGreyText,
                                ),
                                SizedBox(width: 10),
                              ],
                              if (profile.website.isNotEmpty) ...[
                                Icon(
                                  MaterialCommunityIcons.link_variant,
                                  size: 18,
                                  color: theme.accentColor,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'ifeanyi.web.app',
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontSize: Config.xMargin(context, 3.5),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        // SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              MaterialCommunityIcons.calendar_month,
                              size: 16,
                              color: theme.accentColor,
                            ),
                            SizedBox(width: 5),
                            Text(
                              profile.dateJoined,
                              style: _customGreyText,
                            ),
                          ],
                        ),
                        // SizedBox(height: 8),
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
                              style: _customGreyText,
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
                              style: _customGreyText,
                            ),
                          ],
                        ),
                        // SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return Expanded(
            child: Container(
              child: Center(child: Text('no prfile')),
            ),
          );
        },
      );
    });
  }
}
